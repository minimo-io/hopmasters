import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:hopmasters/helpers.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/models/beer.dart';
import 'package:hopmasters/secrets.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/components/async_loader.dart';

import 'package:hopmasters/views/beer_details/components/beer_header.dart';
import 'package:hopmasters/views/beer_details/components/beer_body.dart';


class BeerView extends StatefulWidget {
  static const routeName = "/beer";
  final Object beerId;

  BeerView({ this.beerId });


  @override
  _BeerViewState createState() => _BeerViewState();
}

class _BeerViewState extends State<BeerView> {

  Future _beerFuture;

  Future<Beer> _getBeer()async{
    final String beerUriQuery = WP_BASE_API + WP_REST_WC_VERSION_URI + "products/"+ widget.beerId.toString() +"?_embed&consumer_key="+ WC_CONSUMER_KEY +"&consumer_secret="+WC_CONSUMER_SECRET;
    //print(beerUriQuery);
    final response = await http.get(beerUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){
      var jsonResponse = json.decode(response.body);

      return Beer(
        beerId: widget.beerId.toString(),
        //image: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
        image: jsonResponse["images"][0]["src"],
        followers: jsonResponse['acf']['followers'],
        name: jsonResponse['name'],
        //description: jsonResponse['short_description'],
        description: Helpers.parseHtmlString(jsonResponse['description']),
        abv: jsonResponse['acf']['abv'],
        ibu: jsonResponse['acf']['ibu'],
        launch: jsonResponse['acf']['launch'],
        price: jsonResponse['price'],
        type: jsonResponse['categories'][0]['name'],
        size: jsonResponse['acf']['container'],
        breweryId: jsonResponse['acf']['brewery']['ID'].toString(),
        breweryName: jsonResponse['acf']['brewery']['post_title'],
        breweryImage: jsonResponse['acf']['brewery_image'],

      );


    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load ');
    }
  }

  @override
  void initState() {
    super.initState();
    _beerFuture = _getBeer();
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
        future: _beerFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return AsyncLoader();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return new Scaffold(
                  body: new SingleChildScrollView(
                    child: new Container(
                      decoration: linearGradient,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          BeerHeader(beer: snapshot.data),
                          SizedBox(height: 10,),
                          BeerBody(beer: snapshot.data),
                          SizedBox(height: 500,),
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
