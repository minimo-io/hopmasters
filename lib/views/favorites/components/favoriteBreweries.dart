import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/breweries_cards.dart';


class FavoriteBreweries extends StatefulWidget {
  LoginResponse? loginResponse;
  FavoriteBreweries({
    this.loginResponse,
    Key? key
  }) : super(key: key);

  @override
  _FavoriteBreweriesState createState() => _FavoriteBreweriesState();
}

class _FavoriteBreweriesState extends State<FavoriteBreweries> {

  //LoginResponse? userLogin;

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          WordpressAPI.getUserPrefs( widget.loginResponse?.data?.id, indexType: "breweries_preferences" ),

        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return AsyncLoader(text: "Cargando tus favoritas...",);
              default:
                if (snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                }else{

                  if (snapshot.data[0]["result"] == ""){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Todavía no tenés cervecerías favoritas.", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 15,),
                        Text("Encontralas y seguilas para conocer"),
                        Text("sus lanzamientos y descuentos."),
                        Text("¡Y ganá puntos de prestigio!")
                      ],
                    );
                  }else{
                    return BreweriesCards(
                        loadingText: "Ya casi...",
                        breweriesList: snapshot.data[0]["result"]
                    );
                  }



                }
            }
        });
  }
}

