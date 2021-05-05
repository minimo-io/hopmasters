import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hopmasters/models/brewery.dart';
import 'package:hopmasters/constants.dart';


class BreweriesCards extends StatefulWidget {

  List breweriesList;

  BreweriesCards({
    this.breweriesList,
    Key key
  }) : super(key: key);

  @override
  _BreweriesCardsState createState() => _BreweriesCardsState();
}

class _BreweriesCardsState extends State<BreweriesCards> {

  Future _breweries;

  @override
  void initState() {
    super.initState();
    _breweries = this._getBreweries();
  }

  Future _getBreweries()async{
    final String breweryUriQuery = WP_BASE_API + WP_REST_VERSION_URI + "pages/?parent=89109&_embed";

    final response = await http.get(breweryUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){

      return json.decode(response.body);

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Upa! Failed to load breweries.');
    }
  }

  Widget _buildBreweryCards(List breweries, BuildContext context){

    List<Widget> list = new List<Widget>();
    for(var i = 0; i < breweries.length; i++){

      list.add(GestureDetector(
        onTap: (){
          Navigator.pushNamed(
            context,
            "/brewery",
            arguments: { 'breweryId': int.parse(breweries[i].id) },

          );
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Hero(
                    tag: "brewery-"+breweries[i].id,
                    child: Image.network(
                      breweries[i].avatar,
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
                      Text(breweries[i].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left),
                      Text(breweries[i].followers + " seguidores", style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.left)
                    ]
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: new CircleAvatar(
                          backgroundColor: Colors.black,
                          child: new Icon(
                            Icons.sports_bar,
                            color: Colors.white ,
                            size: 12.0,
                          ),
                          radius: 12.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:6.0),
                          child: Text(breweries[i].beersCount + " cervezas", style: TextStyle(fontSize: 12.0))
                      )
                    ],
                  ),
                )

              ],
              ),
          ),
        ),
      )
      );
      list.add(SizedBox(height:10));
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _breweries,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center( child: CircularProgressIndicator() );
          default:
            if (snapshot.hasError){
              return Text('Ups! Error: ${snapshot.error}');
            }else{
              // return BeerCards(beersList: snapshot.data);

              var breweriesCardsList = (snapshot.data as List)
                  .map((data) => new Brewery.fromJson(data))
                  .toList();



              return Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: _buildBreweryCards(breweriesCardsList, context),
                )
              );
            }
        }
      }
    );
  }
}
