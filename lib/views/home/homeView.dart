import 'package:Hops/models/loader.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/views/home/components/homeNews.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/beer_cards.dart';
import 'package:Hops/components/breweries_cards.dart';
import 'package:Hops/components/app_title.dart';
import 'package:Hops/components/search_bar.dart';
import 'package:Hops/components/score_button.dart';

import 'package:Hops/views/home/components/bannerBreweries.dart';
import 'package:Hops/views/home/components/specialOffers.dart';
import 'package:Hops/views/home/components/discoverBeers.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/constants.dart';
import 'package:provider/provider.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeView extends StatefulWidget {
  final Function(int index)? notifyParent;

  const HomeView({this.notifyParent, Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  Future? _breweryBeers;
  Future? _userScore;
  String _scoreOverview = "";
  late Widget _discoverBeers;
  bool _isLoading = true;
  final String oneSignalAppId = "ab209bbc-1de2-4693-a683-3674d281d4cb";
  bool _moreFilters = false;

  @override
  void initState() {
    super.initState();
    initOneSignalNotifications();
    //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
    _userScore = getUserScore();
    // _discoverBeers = DiscoverBeers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Provider.of<Loader>(context, listen: false).setLoading(true);
      // now i need to check that all loadings are done
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> initOneSignalNotifications() async {
    OneSignal.shared.setAppId(
      oneSignalAppId,
    );
    //OneSignal.shared.disablePush(false);
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      var data = openedResult.notification.additionalData;

      if (data!["post_type"] == "product") {
        Navigator.pushNamed(
          context,
          "/beer",
          arguments: {'beerId': data["post_id"]},
        );
      } else if (data["post_type"] == "brewery") {
        Navigator.pushNamed(
          context,
          "/brewery",
          arguments: {'breweryId': int.parse(data["post_id"].toString())},
        );
      }
    });
  }

  Future getUserScore() async {
    var userData = await SharedServices.loginDetails();
    return WordpressAPI.getUserPrefs(userData!.data!.id, indexType: "score");
  }

  Widget _buildHomeFloatingButtons() {
    return (_moreFilters == true
        ? Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.black,
                label: Text("X",
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        : Container());
  }

  void refreshFromChild() {
    setState(() {
      _moreFilters = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      floatingActionButton: _buildHomeFloatingButtons(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _userScore = getUserScore();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSearchBar) SearchBar(),
                  FutureBuilder(
                      future: _userScore,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return ScoreButton(
                              contrast: "low",
                              score: 0,
                              text: "Cargando puntaje...",
                              image: Image.asset(
                                "assets/images/medal.png",
                                height: 20,
                              ),
                              press: () {},
                            );
                          default:
                            if (snapshot.hasError) {
                              return Text(' Ups! Errors: ${snapshot.error}');
                            } else {
                              _scoreOverview =
                                  snapshot.data["result"].toString();
                              if (_scoreOverview.isEmpty) _scoreOverview = "0";
                              return ScoreButton(
                                contrast: "low",
                                score: int.parse(_scoreOverview),
                                text: _scoreOverview + " puntos canjeables",
                                image: Image.asset(
                                  "assets/images/medal.png",
                                  height: 20,
                                ),
                                press: () {
                                  if (widget.notifyParent != null)
                                    widget.notifyParent!(2);
                                  //Helpers.launchURL("https://hops.uy/revista/novedades/como-funciona-hops/");
                                },
                              );
                            }
                        }
                      }),

                  const SizedBox(
                    height: 10,
                  ),
                  HomeNews(key: UniqueKey(), count: 2),

                  DiscoverBeers(
                    key: UniqueKey(),
                  ),

                  //BreweriesBanner(),
                  const SizedBox(height: (20)),
                  const SpecialOffers(),
                  const SizedBox(height: (30)),
                  const SizedBox(height: (30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTitle(title: "Cervecerías"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: InkWell(
                          onTap: () {
                            Helpers.launchURL(
                                "https://hops.uy/mapa-cervecero/");
                            /*
                            Scaffold.of(context)
                                .showBottomSheet<void>(
                                  (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:  MediaQuery.of(context).size.height,
                                    color: Colors.white,
                                    child: Column(
                                      children: [


                                      ],
                                    ),
                                  ),
                                );
                              },
                              elevation: 25,
                            )
                                .closed
                                .whenComplete(() {

                            });
                            */
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.map,
                                  color: Colors.black26,
                                  size: titlesRightButtonsIconSize),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Mapa",
                                style: TextStyle(
                                    color: BUTTONS_TEXT_DARK,
                                    fontSize: titlesRightButtonsSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: (5)),
                  AppTitle(
                      subtitle:
                          "Las cervecerías mas seguidas por los usuarios."),
                  const SizedBox(height: (15.0)),
                  BreweriesCards(
                    key: UniqueKey(),
                    loadingText: "Cargando cervecerías...",
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
