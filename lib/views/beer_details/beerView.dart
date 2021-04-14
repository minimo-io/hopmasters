import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/models/beer.dart';
import 'package:hopmasters/theme/style.dart';

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

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
    final String beerUriQuery = WP_BASE_API + WP_REST_VERSION_URI + "product/"+ widget.beerId.toString() +"?_embed";
    print(beerUriQuery);
    final response = await http.get(beerUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){

      var jsonResponse = json.decode(response.body);
      return Beer(
        id: widget.beerId.toString(),
        image: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
        followers: jsonResponse['acf']['followers'],
        name: jsonResponse['title']['rendered'],
        description: jsonResponse['excerpt']['rendered'],
        abv: jsonResponse['acf']['abv'],
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
                  appBar: AppBar(
                      title: Text(snapshot.data.name),
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.chevron_left),
                      ),
                      backgroundColor: Colors.transparent,
                      bottomOpacity: 0.0,
                      elevation: 0.0,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                            gradient: PRIMARY_GRADIENT_COLOR
                        ),
                      ),
                  ),
                  body: new SingleChildScrollView(
                    child: new Container(
                      decoration: linearGradient,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          BeerHeader(beer: snapshot.data),
                          SizedBox(height: 20,),
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
