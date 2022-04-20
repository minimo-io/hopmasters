import 'package:Hops/models/loader.dart';
import 'package:Hops/utils/progress_hud.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  Future? _breweryBeers;
  Future? _userScore;
  late Widget _discoverBeers;
  bool _isLoading = true;
  String _scoreOverview = "";

  @override
  void initState() {
    super.initState();
    //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
    _userScore = getUserScore();
    // _discoverBeers = DiscoverBeers();

    WidgetsBinding.instance?.addPostFrameCallback((_){

      //Provider.of<Loader>(context, listen: false).setLoading(true);
      // now i need to check that all loadings are done


    });
  }

  @override
  bool get wantKeepAlive => true;

  Future getUserScore() async {
    var userData = await SharedServices.loginDetails();
    return WordpressAPI.getUserPrefs( userData!.data!.id, indexType: "score" );

  }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh:()async{


          setState(() {
            _userScore = getUserScore();
          });



        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
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
                            text: "Cargando puntaje...",
                            image: Image.asset("assets/images/medal.png", height: 20,),
                            press: () {},
                          );
                        default:
                          if (snapshot.hasError) {
                            return Text(' Ups! Errors: ${snapshot.error}');
                          } else {
                            _scoreOverview = snapshot.data["result"].toString();
                            return ScoreButton(
                              text: "Tenés " + _scoreOverview + " puntos Hops",
                              image: Image.asset("assets/images/medal.png", height: 20,),
                              press: () {

                                Helpers.launchURL("https://hops.uy/revista/novedades/como-funciona-hops/");


                              },
                            );

                          }
                      }
                    }
                ),

                DiscoverBeers(
                  key: UniqueKey()
                ),

                //BreweriesBanner(),
                SizedBox(height: (20)),
                SpecialOffers(),
                SizedBox(height: (30)),
                SizedBox(height: (30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTitle(title: "Cervecerías"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: InkWell(
                        onTap: () {

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

                        },
                        child: Row(
                          children: [
                            Icon(Icons.map, color: Colors.black26,),
                            SizedBox(width: 5,),
                            Text(
                              "Mapa",
                              style: TextStyle(color: BUTTONS_TEXT_DARK),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: (5)),
                AppTitle(subtitle: "Las cervecerías mas seguidas por los usuarios."),
                SizedBox(height: (15.0)),
                BreweriesCards(
                  key: UniqueKey(),
                  loadingText: "Cargando cervecerías...",
                ),

                SizedBox(height: (100)),
              ],
            ),
          ),
        ),
      ),
    );


  }
}