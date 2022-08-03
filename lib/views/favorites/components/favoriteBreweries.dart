import 'package:Hops/constants.dart';
import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/breweries_cards.dart';

class FavoriteBreweries extends StatefulWidget {
  LoginResponse? loginResponse;
  FavoriteBreweries({this.loginResponse, Key? key}) : super(key: key);

  @override
  _FavoriteBreweriesState createState() => _FavoriteBreweriesState();
}

class _FavoriteBreweriesState extends State<FavoriteBreweries>
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
    super.build(context);
    return FutureBuilder(
        future: Future.wait([
          WordpressAPI.getUserPrefs(widget.loginResponse?.data?.id,
              indexType: "breweries_preferences"),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AsyncLoader(
                text: "Cargando tus cervecerías favoritas...",
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data[0]["result"] == "") {
                  return SizedBox(
                    width: double.infinity,
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
                        const Text("Todavía no tenés cervecerías favoritas.",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text("Encontralas y seguilas para conocer"),
                        const Text("sus lanzamientos y descuentos."),
                        const Text("¡Y ganá Puntos Hops!")
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: BreweriesCards(
                        loadingText: "Ya casi...",
                        breweriesList: snapshot.data[0]["result"]),
                  );
                }
              }
          }
        });
  }
}
