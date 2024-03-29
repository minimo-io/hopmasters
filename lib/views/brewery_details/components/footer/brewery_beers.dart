import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/models/brewery.dart';
import 'package:Hops/components/beer_cards.dart';

class BreweryBeers extends StatefulWidget {
  Brewery? brewery;

  BreweryBeers({ this.brewery });

  @override
  _BreweryBeersState createState() => _BreweryBeersState();
}

class _BreweryBeersState extends State<BreweryBeers> {
  Future? _breweryBeers;

  @override
  void initState() {
    super.initState();
    _breweryBeers = WordpressAPI.getBeersFromBreweryID(widget.brewery!.id);
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return FutureBuilder(
        future: _breweryBeers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center( child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,) );
            default:

              if (snapshot.hasError){
                return Text('Ups! Error: ${snapshot.error}');
              }else{
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SingleChildScrollView(
                      child: BeerCards(beersList: snapshot.data)
                  ),
                );
                /*
                return GridView(
                  padding: const EdgeInsets.only(top: 16.0),
                  gridDelegate: delegate,
                  //children: _buildItems(),
                );
                 */
              }
          }
        }
    );
  }
}
