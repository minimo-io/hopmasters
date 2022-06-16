import 'package:Hops/components/app_title.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/text_expandable.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/promo.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:Hops/views/promos/components/promos_header.dart';
import 'package:Hops/models/cart.dart';

import 'package:Hops/components/score_mini_button.dart';

class PromosView extends StatefulWidget {
  static const String routeName = "promos";
  const PromosView({Key? key}) : super(key: key);

  @override
  State<PromosView> createState() => _PromosViewState();
}

class _PromosViewState extends State<PromosView>
    with AutomaticKeepAliveClientMixin {
  bool showFilters = true;
  // future for lat, lon
  Future<LocationData?>? _latLonFuture;
  // future for promos, send lat, lon
  Future? _promosFuture;
  // user data
  LoginResponse? _userData;

  static List<Filters> _filters = [
    Filters(id: 1, name: "En bares"),
    Filters(id: 2, name: "Por pedidos online"),
    Filters(id: 3, name: "Puntos Hops"),
  ];
  List _selectedFilters = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    //super.initState();

    _promosFuture = getPromos();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _promosFuture!.then((beerData) {
        print("Promos loaded.");
      });
    });
  }

  Future? getPromos() async {
    _userData = await SharedServices.loginDetails();

    return await WordpressAPI.getPromos(
        //latLon: _userData!.data!.id.toString()
        );
  }

  Widget _buildPromoBox(Promo promo, {bool isExpanded = false}) {
    String scoreText = (int.parse(promo.pointsScore!) > 0 ? '+' : '') +
        promo.pointsScore.toString();
    if (int.parse(promo.pointsScore!) == 0) scoreText = "Gratis";
    DateTime currentDateTime = DateTime.now();
    DateTime? parsedDate;
    if (promo.dateLimit != null && promo.dateLimit != "") {
      parsedDate = DateTime.parse(promo.dateLimit.toString());
    }

    // expired text
    Widget expiredWidget = Container();
    if (parsedDate != null && currentDateTime.isAfter(parsedDate)) {
      expiredWidget = Container(
          height: 18,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.red.withOpacity(.8),
              shape: BoxShape.rectangle,
              border: Border.all(width: 0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Text("Expiró",
                  style: TextStyle(
                      fontSize: 11,
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w600))));
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: "promo-" + promo.id.toString(),
                    child: ClipOval(
                      child: Image.network(
                        promo.avatar!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 8,),
                // Row(children: [
                //   Image.asset("assets/images/medal.png", height: 15,),

                //   Text(scoreText),
                // ],)
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(promo.name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                          textAlign: TextAlign.left),
                      const SizedBox(
                        height: 3,
                      ),
                      TextExpandable(
                        Helpers.parseHtmlString(promo.description!),
                        linesToShow: 1,
                        isExpanded: isExpanded,
                        callToActionWidget: Row(
                          children: [
                            expiredWidget,
                            if (parsedDate == null ||
                                currentDateTime.isBefore(parsedDate))
                              Consumer<Cart>(builder: (context, cart, child) {
                                return ElevatedButton.icon(
                                    icon: Icon(
                                      promo.callToActionIcon,
                                      size: 15,
                                    ),
                                    label: Text(
                                      promo.callToActionText.toString(),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 0)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                promo.rgbColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(10.0)),
                                                side: (1 == 1 ? BorderSide(style: BorderStyle.none) : BorderSide(color: Colors.white24))))),
                                    onPressed: () {
                                      // share with friends
                                      if (promo.callToActionIcon ==
                                          Icons.share) {
                                        Share.share(
                                            'Descargate HOPS ¡y ganemos descuentos en birras juntos! https://hops.uy/',
                                            subject:
                                                'Descargate la app de HOPS y ganemos descuentos!');
                                      }
                                      // scan QR option
                                      if (promo.callToActionIcon ==
                                          Icons.qr_code_scanner) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'En próximas versiones vas a poder comprar con Hops via QR en bares y acceder a descuentos y beneficios.')),
                                        );
                                      }
                                      // add promo item to cart
                                      if (promo.callToActionIcon ==
                                          Icons.shopping_cart) {
                                        if (promo.channelType == "cartbuy") {
                                          Navigator.pushNamed(
                                            context,
                                            "/beer",
                                            arguments: {
                                              'beerId': int.parse(promo
                                                  .productAssociated
                                                  .toString())
                                            },
                                          );
                                        } else if (promo.channelType ==
                                            "brewerybuy") {
                                          Navigator.pushNamed(
                                            context,
                                            "/brewery",
                                            arguments: {
                                              'breweryId': int.parse(promo
                                                  .breweryAssociated!.id
                                                  .toString())
                                            },
                                          );
                                        }
                                      }
                                    });
                              }),
                          ],
                        ),
                      ),

                      /*
                      StarsScore(
                          opinionCount: 0,
                          opinionScore: double.parse(comment.rating!),
                          onlyStars: true
                      )
                       */
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _promosFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AsyncLoader(
                text: "Cargando promos...",
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Widget> promosCardList = <Widget>[];

                if (snapshot.hasData && snapshot.data.length > 0) {
                  for (var i = 0; i < snapshot.data.length; i++) {
                    Promo promo = Promo.fromJson(snapshot.data[i]);
                    promosCardList.add(_buildPromoBox(promo,
                        isExpanded: (i == 0 ? true : false)));
                  }
                }
                promosCardList.add(SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                ));

                return SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _promosFuture = getPromos();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: PRIMARY_GRADIENT_COLOR,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: marginSide,
                            ),
                            // AppTitle(title: "Promos"),
                            const PromosHeader(),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextExpandable(
                                "Gana puntos y accedé a cualquier de estos beneficios con tus compras online a través de HOPS. " +
                                    "Canjeá tus puntos por descuentos y beneficos en los bares asociados.",
                                linesToShow: 2,
                              ),
                            ),

                            if (showFilters)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: marginSide, vertical: 10),
                                child: MultiSelectChipField(
                                  searchable: false,
                                  showHeader: false,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(style: BorderStyle.none)),
                                  //decoration: BoxDecoration(border: BoxBorder),

                                  initialValue: _selectedFilters,
                                  items: _filters
                                      .map((e) => MultiSelectItem(e, e.name))
                                      .toList(),
                                  icon: Icon(Icons.check),

                                  onTap: (values) {
                                    _selectedFilters = values;
                                  },
                                ),
                              ),

                            if (!showFilters)
                              SizedBox(
                                height: 10,
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: marginSide),
                              child: Column(
                                children: promosCardList,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          }
        });
  }
}

class Filters {
  final int id;
  final String name;

  Filters({
    required this.id,
    required this.name,
  });
}
