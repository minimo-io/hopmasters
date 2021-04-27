import 'package:flutter/material.dart';
import 'package:hopmasters/models/brewery.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:hopmasters/constants.dart';

class BreweryBeers extends StatefulWidget {
  Brewery brewery;

  BreweryBeers({ this.brewery });

  @override
  _BreweryBeersState createState() => _BreweryBeersState();
}

class _BreweryBeersState extends State<BreweryBeers> {
  Future _breweryBeers;

  Future _getBeersFromBreweryID()async{
    final String beersFromBreweryUriQuery = WP_BASE_API + WP_REST_HOPS_VERSION_URI + "beers/breweryID/"+ widget.brewery.id.toString() +"/?_embed";
    print(beersFromBreweryUriQuery);
    final response = await http.get(beersFromBreweryUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){

      var jsonResponse = json.decode(response.body);
      /*
      _breweryBeers = Brewery(
        avatar: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
        location: jsonResponse['acf']['location'],
        followers: jsonResponse['acf']['followers'],
        beersCount: jsonResponse['acf']['beers_count'],
        bgColor: jsonResponse['acf']['bg_color'],
        name: jsonResponse['title']['rendered'],
        description: jsonResponse['excerpt']['rendered'],
      );
      */
      //_breweryBeers = jsonResponse;
      return jsonResponse;


    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load beers.');
    }
  }

  @override
  void initState() {
    super.initState();
    _breweryBeers = _getBeersFromBreweryID();
    print(_breweryBeers);
  }

  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var image = new Image.asset(
        'assets/images/portfolio_$i.jpeg',
        width: 200.0,
        height: 200.0,
      );

      items.add(image);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return new GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: _buildItems(),
    );
  }
}
