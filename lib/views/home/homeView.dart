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

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  Future? _breweryBeers;
  Future? _userScore;
  late Widget _discoverBeers;

  @override
  void initState() {
    super.initState();
    //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
    _userScore = getUserScore();
    _discoverBeers = DiscoverBeers();
    print(_discoverBeers);
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
      child: SingleChildScrollView(
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
                        return Container();
                      default:
                        if (snapshot.hasError) {
                          return Text(' Ups! Errors: ${snapshot.error}');
                        } else {
                          return ScoreButton(
                            text: "¡Hola! Tenés " + snapshot.data["result"].toString() + " puntos Hops",
                            image: Image.asset("assets/images/medal.png", height: 20,),
                            press: () {

                              Helpers.launchURL("https://hops.uy/revista/novedades/como-funciona-hops/");


                            },
                          );

                        }
                    }
                  }
              ),

              //DiscoverBeers(),
              _discoverBeers,

              //BreweriesBanner(),
              SizedBox(height: (20)),
              SpecialOffers(),
              SizedBox(height: (30)),


              //SizedBox(height: (30)),



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
              BreweriesCards(),

              SizedBox(height: (100)),
            ],
          ),
        ),
      ),
    );
  }
}