import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/theme/style.dart';

import 'dart:async';
import 'package:Hops/models/brewery.dart';


class BreweriesCards extends StatefulWidget {

  String? breweriesList; // possible favorite breweries to call
  String? loadingText;

  BreweriesCards({
    this.breweriesList,
    this.loadingText,
    Key? key
  }) : super(key: key);

  @override
  _BreweriesCardsState createState() => _BreweriesCardsState();
}

class _BreweriesCardsState extends State<BreweriesCards> {

  Future? _breweries;

  @override
  void initState() {
    super.initState();

    if (widget.breweriesList != null){
      _breweries = WordpressAPI.getBreweries(userBreweries: widget.breweriesList!);
    }else{
      _breweries = WordpressAPI.getBreweries( orderType: 'followers' );
    }
  }

  Widget _buildBreweryCards(List breweries, BuildContext context){

    //List<Widget> list = new List<Widget>();
    List<Widget> list = <Widget>[];
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
      list.add(SizedBox(height:0));
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
            return Center( child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,),
                if (widget.loadingText != null) Padding(padding:EdgeInsets.only(top:10), child: Text(widget.loadingText!))
              ],
            ) );
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
