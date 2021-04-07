import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/models/brewery.dart';

import 'package:hopmasters/views/brewery_detail/components/footer/brewery_detail_footer.dart';
import 'package:hopmasters/views/brewery_detail/components/brewery_detail_body.dart';
import 'package:hopmasters/views/brewery_detail/components/header/brewery_detail_header.dart';


class BreweryView extends StatefulWidget {
  static const routeName = "/brewery";

  final Object breweryId;

  BreweryView({ this.breweryId });

  @override
  _BreweryViewState createState() => new _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {
  //Future<Brewery> _brewery;
  Brewery _brewery;
  Future _breweryFuture;
  Future<Brewery> _getBrewery()async{
    final String BreweryUriQuery = WP_BASE_API + WP_REST_VERSION_URI + "pages/"+ widget.breweryId.toString() +"?_embed";

    final response = await http.get(BreweryUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){

      var jsonResponse = json.decode(response.body);

      _brewery = Brewery(
        avatar: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
        location: jsonResponse['acf']['location'],
        followers: jsonResponse['acf']['followers'],
        beersCount: jsonResponse['acf']['beers_count'],
        bgColor: jsonResponse['acf']['bg_color'],
        name: jsonResponse['title']['rendered'],
        description: jsonResponse['excerpt']['rendered'],
      );
      return _brewery;


    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load ');
    }
  }

  @override
  void initState() {
    super.initState();
    _breweryFuture = _getBrewery();
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
      future: _breweryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Scaffold(body:Center(child:CircularProgressIndicator()));
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              // return Text('Result: ${snapshot.data}');
              return new Scaffold(
                body: new SingleChildScrollView(
                  child: new Container(
                    decoration: linearGradient,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new BreweryDetailHeader(
                          snapshot.data,
                          avatarTag: "brewery-" + widget.breweryId.toString(),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: new BreweryDetailBody(snapshot.data),
                        ),
                        new BreweryShowcase(snapshot.data),
                      ],
                    ),
                  ),
                ),
              );
        }


      }
    );



  }
}
