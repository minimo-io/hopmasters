import 'package:Hops/constants.dart';
import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/beer_cards.dart';

class FavoriteBeers extends StatefulWidget {
  LoginResponse? loginResponse;
  FavoriteBeers({this.loginResponse, Key? key}) : super(key: key);

  @override
  _FavoriteBeersState createState() => _FavoriteBeersState();
}

class _FavoriteBeersState extends State<FavoriteBeers>
    with AutomaticKeepAliveClientMixin {
  //LoginResponse? userLogin;

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          WordpressAPI.getUserPrefs(widget.loginResponse?.data?.id,
              indexType: "beers_favorites_preference"),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AsyncLoader(
                text: "Cargando tus cervezas favoritas...",
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data[0]["result"] == "") {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            noResultsIcon,
                            height: 45,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Todavía no tenés cervezas favoritas.",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Descubrilas y seguilas para conocer"),
                          const Text("novedades y descuentos."),
                          const Text("¡Y ganá Puntos de Hops!")
                        ],
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: BeerCards(
                      loadingText: "Ya casi...",
                      userBeersList: snapshot.data[0]["result"],
                      discoverBeersType: 'user_beers',
                    ),
                  );
                }
              }
          }
        });
  }
}
