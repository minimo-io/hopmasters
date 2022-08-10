import 'dart:ui';
import 'package:Hops/components/alert_box.dart';
import 'package:Hops/components/hops_button.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/utils/notifications.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/bar.dart';

import 'package:Hops/components/diagonally_cut_colored_image.dart';
import 'package:Hops/utils/load_network_image.dart';
import 'package:Hops/components/followers_info.dart';

// import 'package:Hops/components/counter_selector.dart';
import 'package:Hops/components/counter_selector_big.dart';

import 'package:Hops/helpers.dart';

import 'package:provider/provider.dart';

import 'package:location/location.dart';

import 'package:Hops/constants.dart';

class BeerHeader extends StatefulWidget {
  final Function() notifyParent;

  BeerHeader(
      {required Beer? this.beer, this.userData, required this.notifyParent});

  final beer;
  final LoginResponse? userData;

  @override
  _BeerHeaderState createState() => _BeerHeaderState();
}

class _BeerHeaderState extends State<BeerHeader>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>?> _userBeersPreferences;
  bool _isBeerIncluded = false;
  bool _isLoadingApiCall = false;
  int _itemsCount = 1;
  Future<LocationData?>? _location;

  @override
  void initState() {
    _userBeersPreferences = WordpressAPI.getUserPrefs(widget.userData?.data?.id,
        indexType: "beers_favorites_preference");

    /*
    // ask for location
    Helpers.askForLocation()?.then((location){
      print(location);
      setState(() {
        this._location = location;
      });

    });
    */
    _location = Helpers.askForLocation();

    void defineBeers(BuildContext context) async {
      _userBeersPreferences.then((beers_prefs) {
        String beersFollowed =
            (beers_prefs!["result"] != null ? beers_prefs["result"] : "");
        String beerId =
            (widget.beer?.beerId != null ? widget.beer!.beerId : '');
        bool isBeerIncluded = beersFollowed.contains(beerId);

        setState(() {
          this._isBeerIncluded = isBeerIncluded;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      defineBeers(context);
    });
  }

  Widget _buildBeerAvatar() {
    return new Align(
      alignment: FractionalOffset.bottomCenter,
      heightFactor: 1.2,
      child: new Column(
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          Hero(
            tag: "beer-" + widget.beer.beerId,
            child: LoadNetworkImage(
              uri: widget.beer.image,
              height: 230,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeerPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "\$" + this.widget.beer.price,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    Widget _buildButton(
        {required Text text,
        required Icon icon,
        Function? doOnPressed = null,
        bool isGrey = false}) {
      return HopsButton(
        text: text,
        icon: icon,
        bgColor: widget.beer.rgbColor,
        doOnPressed: doOnPressed,
        isGrey: isGrey,
      );
    }

    Widget _unfollowButton() {
      return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _buildButton(
              isGrey: true,
              text: const Text("ABANDONAR"),
              icon: const Icon(Icons.close),
              doOnPressed: _unfollowAction));
    }

    Widget _followButton() {
      return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _buildButton(
              text: const Text("FAVORITA"),
              icon: const Icon(Icons.favorite_border_outlined),
              doOnPressed: _followAction));
    }

    Widget _buildOnlineShopCard(
        {String id = "",
        String name = "",
        double price = 0.00,
        String logo = "",
        bool isVerified = true,
        bool isOfficial = false,
        String storeBeerUrl = "",
        String priceLastUpdate = ""}) {
      return InkWell(
        onTap: () {
          if (storeBeerUrl != null) Helpers.launchURL(storeBeerUrl);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: "shop-" + id,
                  child: Image.network(
                    logo,
                    fit: BoxFit.cover, // this is the solution for border
                    width: 55.0,
                    height: 55.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                            textAlign: TextAlign.left),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            if (isOfficial)
                              Badge(
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3.0),
                                toAnimate: false,
                                shape: BadgeShape.square,
                                borderRadius: BorderRadius.circular(8),
                                badgeColor: Colors.blueAccent.withOpacity(.5),
                                badgeContent: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Icon(
                                        Icons.verified,
                                        size: 15,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      "Oficial",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11.0),
                                    ),
                                  ],
                                ),
                              ),
                            if (priceLastUpdate != "")
                              Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(priceLastUpdate,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.0))),
                          ],
                        ),

                        if (isVerified)
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: new CircleAvatar(
                                    backgroundColor:
                                        const Color.fromRGBO(25, 119, 227, 1),
                                    child: new Icon(
                                      Icons.gpp_good,
                                      color: Colors.white,
                                      size: 10.0,
                                    ),
                                    radius: 10.0,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Text("verificado",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12.0)))
                              ],
                            ),
                          )

                        // Text(address, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.left)
                      ]),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 6.0, right: 10.0),
                          child: Text("\$" + price.round().toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.black54)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildShopCard(
        {required String id,
        String? name = "",
        String? address = "",
        String? logo = "",
        bool isVerified = true}) {
      return GestureDetector(
        onTap: () {
          Helpers.launchURL(siteUrl + "/?p=" + id);
          /*
          Navigator.pushNamed(
            context,
            "/brewery",
            arguments: { 'breweryId': int.parse(breweries[i].id) },

          );

           */
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (logo != null)
                  Hero(
                    tag: "shop-" + id,
                    child: Image.network(
                      logo,
                      fit: BoxFit.cover, // this is the solution for border
                      width: 55.0,
                      height: 55.0,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name != null)
                            Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left),
                          if (address != null)
                            Text(address,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                textAlign: TextAlign.left)
                        ]),
                  ),
                ),
                if (isVerified)
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(25, 119, 227, 1),
                            child: Icon(
                              Icons.gpp_good,
                              color: Colors.white,
                              size: 12.0,
                            ),
                            radius: 12.0,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text("destacado",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.0)))
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildOnlineStores(int itemCount) {
      return Column(
        children: [
          Container(
              padding: const EdgeInsets.only(left: 20, top: 0),
              //height: 50,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("TIENDAS ONLINE",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )),
          const SizedBox(
            height: 15,
          ),
          if (widget.beer.stores != null)
            for (var store in widget.beer.stores)
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: _buildOnlineShopCard(
                      id: store.id,
                      name: store.name,
                      price: double.parse(
                          (int.parse(store.price) * itemCount).toString()),
                      priceLastUpdate: store.priceLastUpdate,
                      logo: store.image,
                      storeBeerUrl: store.url,
                      isOfficial: store.isOfficial,
                      isVerified: (store.isVerified.toLowerCase() == "true"
                          ? true
                          : false))),
          if (widget.beer.stores == null)
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: const Text(
                  "Ninguna otra tienda online tiene esta cerveza.",
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: Colors.black38),
                )),
        ],
      );
    }

    Widget _buildShops(List<Bar> barsList) {
      List<Widget> barWidgetList = [];
      // print(barsList[0].name);
      for (var bar in barsList) {
        barWidgetList.add(Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                //padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buildShopCard(
                    id: bar.id,
                    name: bar.name,
                    address: bar.address,
                    logo: bar.avatar))));
      }
      barWidgetList.add(const SizedBox(
        height: 50,
      ));

      return Column(
        children: barWidgetList,
      );
      /*
      return Column(children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.90,
            //padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildShopCard(name: "Nino Bar", address: "Bartolome Mitre 1316.", logo: "assets/images/nino-bar-logo.png")
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.90,
            //padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildShopCard(name: "Pepe Botella", address: "José Enrique Rodó 2052.", logo: "assets/images/pepebotella-logo.png")
        ),
      ],);

       */
    }

    HopsNotifications notificationClient = HopsNotifications();

    double getItemsFinalPrice(int itemsCount, double price) {
      return itemsCount * price;
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: const Text("Seguir agregando"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.shopping_cart,
              size: 18.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("Ir al pago"),
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            "/cart",
          );
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("¿Querés ir a finalizar la compra?"),
        backgroundColor: Colors.white,
        //content: const Text("¿Ir a finalizar la compra?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cancelButton,
              continueButton,
            ],
          ),
        ],
      );
      // show the dialog

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Padding(
        padding: const EdgeInsets.only(
          top: 1.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Row(
          /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // (_isBeerIncluded ? _unfollowButton() : _followButton() ),
            // (
            //     widget.beer.stockStatus == "instock"
            //     ? CounterSelector(
            //         color: widget.beer.rgbColor,
            //         notifyParent: (int items){
            //           setState( () => _itemsCount = items );
            //         }
            //       )
            //     : Container()
            // ) ,

            Padding(
                padding: const EdgeInsets.only(left: 2),
                child: _buildButton(
                    text: const Text("OPCIONES DE COMPRA"),
                    icon: const Icon(Icons.shopping_cart),
                    doOnPressed: () {
                      //Helpers.showPersistentBottomSheet(context);
                      BuildContext oldContext = context;
                      widget.notifyParent();

                      Scaffold.of(context)
                          .showBottomSheet<void>(
                            (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    // height: (widget.height != null ? widget.height : 430),
                                    // height: (430),
                                    height: MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        kToolbarHeight -
                                        20,
                                    color: Colors.white,
                                    child: ListView(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 20),
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  (widget.beer.stockStatus ==
                                                          "instock"
                                                      ? "COMPRA VERIFICADA"
                                                      : "COMPRAR"),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )),
                                        if (widget.beer.stockStatus ==
                                            "instock")
                                          const SizedBox(
                                            height: 20,
                                          ),

                                        /*
                                        Divider(
                                          thickness: 1,
                                        ),
                                        */
                                        // direct buy

                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Consumer<Cart>(builder:
                                                (context, cart, child) {
                                              return Row(
                                                /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  // (_isBeerIncluded ? _unfollowButton() : _followButton() ),
                                                  (widget.beer.stockStatus ==
                                                          "instock"
                                                      ? CounterSelectorBig(
                                                          counterPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 0.0,
                                                                  horizontal:
                                                                      0.0),
                                                          color: widget
                                                              .beer.rgbColor,
                                                          notifyParent:
                                                              (int items) {
                                                            setState(() =>
                                                                _itemsCount =
                                                                    items);
                                                          })
                                                      : Container()),
                                                ],
                                              );
                                            })),

                                        if (widget.beer.stockStatus ==
                                            "instock")
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Consumer<Cart>(builder:
                                                  (context, cart, child) {
                                                return ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: (widget
                                                                .beer
                                                                .stockStatus ==
                                                            "instock"
                                                        ? MaterialStateProperty
                                                            .all(widget
                                                                .beer.rgbColor
                                                                .withOpacity(
                                                                    0.95))
                                                        : MaterialStateProperty
                                                            .all(Colors.grey
                                                                .withOpacity(
                                                                    0.95))),
                                                  ),
                                                  onPressed: (widget.beer
                                                              .stockStatus ==
                                                          "instock"
                                                      ? () async {
                                                          // add this beer to cart
                                                          cart.add(CartItem(
                                                              beer: widget.beer,
                                                              itemCount:
                                                                  _itemsCount,
                                                              itemPrice: double.parse(
                                                                      _itemsCount
                                                                          .toString()) *
                                                                  double.parse(
                                                                      widget
                                                                          .beer
                                                                          .price)));

                                                          // notificationClient.message(
                                                          //     context,
                                                          //     "Birra agregada al carrito.",
                                                          //     //action: "goToCart",
                                                          //     callback: () {
                                                          //   // Navigator.pushNamed(
                                                          //   //     oldContext,
                                                          //   //     "/cart",
                                                          //   //     );
                                                          // });

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pushNamed(
                                                              context, "/cart");
                                                          // showAlertDialog(
                                                          //     oldContext);
                                                        }
                                                      : null),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 4.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                            //mainAxisAlignment: MainAxisAlignment.start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              if (widget.beer
                                                                      .stockStatus ==
                                                                  "instock")
                                                                const Icon(
                                                                    Icons
                                                                        .shopping_cart,
                                                                    size: 35,
                                                                    color: Colors
                                                                        .white),
                                                              // if (widget.beer
                                                              //         .stockStatus !=
                                                              //     "instock")
                                                              //   const Icon(
                                                              //       Icons.error,
                                                              //       size: 35,
                                                              //       color: Colors
                                                              //           .white),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                                              Text(
                                                                (widget.beer.stockStatus ==
                                                                        "instock"
                                                                    ? "Agregar al carrito · \$" +
                                                                        (getItemsFinalPrice(
                                                                          _itemsCount,
                                                                          double.parse(widget
                                                                              .beer
                                                                              .price),
                                                                        )
                                                                            .round()
                                                                            .toString())
                                                                    : "Sin stock"),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ]),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })),
                                        if (widget.beer.stockStatus ==
                                            "instock")
                                          const SizedBox(
                                            height: 7,
                                          ),

                                        // whatsapp
                                        if (SHOW_BREWERY_WHATSAPP_ON_BEER_BUY_OPTIONS ==
                                                true ||
                                            widget.beer.stockStatus !=
                                                "instock")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 10.0,
                                                bottom: 0.0),
                                            child: Flexible(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  /*
                                    void _launchURL(String _url) async => await canLaunch(_url)
                                        ? await launch(_url) : notificationClient.message(context, "¡Parece que no tienes whatsapp instalado!");


                                    _launchURL("whatsapp://send?phone="+widget.beer.breweryWhatsapp+"&text=");
   */

                                                  Helpers.launchURL(
                                                      "https://wa.me/" +
                                                          widget.beer
                                                              .breweryWhatsapp
                                                              .toString()
                                                              .replaceAll(
                                                                  " ", "")
                                                              .replaceAll(
                                                                  "+", "") +
                                                          "?text=");
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                      //mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/icons/whatsapp-logo-2.png",
                                                          height: 35,
                                                          width: 35,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                                        Expanded(
                                                          child: Text(
                                                            "Whatsapp de " +
                                                                widget.beer
                                                                    .breweryName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          ),

                                        if (widget.beer.stockStatus ==
                                            "instock")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            padding: const EdgeInsets.only(
                                                right: 20.0,
                                                left: 20,
                                                top: 10.0,
                                                bottom: 0),
                                            child: const Text(
                                              "Con la compra en HOPS ganás puntos canjeables por descuentos en las tiendas y bares asociados.",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.black38),
                                            ),
                                          ),

                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          child: (widget.beer.stockStatus ==
                                                  "instock"
                                              ? const Divider()
                                              : Container()),
                                        ),

                                        // SizedBox(
                                        //   height: 5,
                                        // ),

                                        Consumer<Cart>(
                                            builder: (context, cart, child) {
                                          return _buildOnlineStores(
                                              _itemsCount);
                                          //return Container(child: Text( _itemsCount.toString() ));
                                        }),

                                        const SizedBox(
                                          height: 30,
                                        ),

                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 0),
                                            //height: 50,
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("BARES",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )),
                                        FutureBuilder(
                                            future: _location,
                                            builder: (context, snapshot) {
                                              if (snapshot != null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0,
                                                          left: 20.0,
                                                          top: 10.0),
                                                  child: Container(),
                                                );
                                              } else {
                                                return Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0,
                                                            left: 20.0,
                                                            top: 10.0),
                                                    child: AlertBox(
                                                        text:
                                                            "Habilita la ubicación para ver los bares cercanos.",
                                                        icon: Icons.place),
                                                  ),
                                                );
                                              }
                                            }),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        FutureBuilder(
                                          future: _location,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.data != null) {
                                              return FutureBuilder(
                                                  future: WordpressAPI.getBars(
                                                      isFeatured: 1,
                                                      location: snapshot.data),
                                                  builder: (context,
                                                      AsyncSnapshot snapshot2) {
                                                    switch (snapshot2
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        return Center(
                                                            child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Image.asset(
                                                              "assets/images/loader-hops.gif",
                                                              width: 100,
                                                            ),
                                                            const Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                child: const Text(
                                                                    "Cargando bares...")),
                                                            const SizedBox(
                                                                height: 10),
                                                          ],
                                                        ));
                                                      default:
                                                        if (snapshot2
                                                            .hasError) {
                                                          return Text(
                                                              'Ups! Error: ${snapshot2.error}');
                                                        } else {
                                                          var barsCardsList =
                                                              (snapshot2.data
                                                                      as List)
                                                                  .map((data) =>
                                                                      new Bar.fromJson(
                                                                          data))
                                                                  .toList();

                                                          return _buildShops(
                                                              barsCardsList);
                                                        }
                                                    }
                                                  });
                                            } else {
                                              return Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child:
                                                            ElevatedButton.icon(
                                                          label: const Text(
                                                            "Habilitar ubicación",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          icon: const Icon(
                                                            Icons.send,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () {
                                                            Helpers.askForLocation()
                                                                ?.then(
                                                                    (location) {});
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                            }
                                          },
                                        ),

                                        const SizedBox(height: 5)
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                            elevation: 25,
                          )
                          .closed
                          .whenComplete(() {});
                    }))
          ],
        ));
  }

  void _followAction() async {
    HopsNotifications notificationClient = new HopsNotifications();
    try {
      // get user details

      int? userId = widget.userData?.data?.id;
      int beerId = int.parse(widget.beer!.beerId);
      setState(() => this._isLoadingApiCall = true);
      // api call
      bool favRest = await WordpressAPI.editBeerPref(
          (userId != null ? userId : 0), beerId,
          addOrRemove: "add");

      if (favRest == true) {
        setState(() => this._isLoadingApiCall = false);
        //setState(() => this._breweryFollowersCount++  );
        setState(() {
          this._isBeerIncluded = true;
        });

        notificationClient.message(
            context, WordpressAPI.MESSAGE_OK_FOLLOWING_BREWERY);
      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(error);
    }
  }

  void _unfollowAction() async {
    HopsNotifications notificationClient = new HopsNotifications();
    try {
      // get user details

      int? userId = widget.userData?.data?.id;
      int beerId = int.parse(widget.beer!.beerId);
      setState(() => this._isLoadingApiCall = true);
      // api call
      bool favRest = await WordpressAPI.editBeerPref(
          (userId != null ? userId : 0), beerId,
          addOrRemove: "remove");

      if (favRest == true) {
        setState(() => this._isLoadingApiCall = false);
        //setState(() => this._breweryFollowersCount++  );
        setState(() {
          this._isBeerIncluded = false;
        });

        notificationClient.message(
            context, WordpressAPI.MESSAGE_OK_FOLLOWING_BREWERY);
      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(error);
    }
  }

  Widget _followIconButton() {
    return InkWell(
        onTap: _followAction,
        child: const Icon(
          Icons.favorite_border,
          color: Colors.white,
        ));
  }

  Widget _unfollowIconButton() {
    return InkWell(
        onTap: _unfollowAction,
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
        ));
  }

  Widget _buildFavoriteButton() {
    return FutureBuilder(
        future: _userBeersPreferences,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                  height: 22,
                  width: 22,
                  child: const CircularProgressIndicator(
                    color: PROGRESS_INDICATOR_COLOR,
                    strokeWidth: 1,
                  ));
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (_isLoadingApiCall == true) {
                  return const SizedBox(
                      height: 22,
                      width: 22,
                      child: const CircularProgressIndicator(
                        color: PROGRESS_INDICATOR_COLOR,
                        strokeWidth: 1,
                      ));
                }
                return (_isBeerIncluded
                    ? _unfollowIconButton()
                    : _followIconButton());
              }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    double safePadding = Helpers.getTopSafeArea(context);

    return Stack(
      children: <Widget>[
        DiagonallyCutColoredImage(
            Image.asset(
              "assets/images/beer_bg_bw2.png",
              width: MediaQuery.of(context).size.width,
              height: 440,
              fit: BoxFit.cover,
            ),
            //color: colorScheme.background.withOpacity(0.75)
            color: widget.beer.rgbColor.withOpacity(0.35)),
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,
          child: Column(
            children: <Widget>[
              _buildBeerAvatar(),
              _buildBeerPrice(),
              //FollowersInfo(this.beer.followers, textColor: SECONDARY_TEXT_DARK),
              //if (_isLoadingApiCall == true) Padding(padding:EdgeInsets.only(top:16), child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR)) else _buildActionButtons(Theme.of(context), context),
              _buildActionButtons(Theme.of(context), context),
            ],
          ),
        ),
        Positioned(
          top: 15.0 + safePadding,
          left: 4.0,
          child: const BackButton(color: Colors.white),
        ),
        Positioned(
          top: 28.0 + safePadding,
          right: 60.0,
          child: _buildFavoriteButton(),
        ),
        Positioned(
          top: 28.0 + safePadding,
          right: 20.0,
          child: InkWell(
              onTap: () {
                Share.share(
                  'Mirá este cerveza, te puede interesar https://hops.uy/?p=' +
                      widget.beer.beerId,
                );
              },
              child: const Icon(
                Icons.share,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
