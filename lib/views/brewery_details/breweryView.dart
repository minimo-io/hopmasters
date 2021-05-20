import 'package:flutter/material.dart';
import 'package:hopmasters/services/wordpress_api.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/models/brewery.dart';
import 'package:hopmasters/components/async_loader.dart';

import 'package:hopmasters/views/brewery_details/components/footer/brewery_showcase.dart';
import 'package:hopmasters/views/brewery_details/components/brewery_detail_body.dart';
import 'package:hopmasters/views/brewery_details/components/header/brewery_detail_header.dart';


class BreweryView extends StatefulWidget {
  static const routeName = "/brewery";

  final Object breweryId;

  BreweryView({ this.breweryId });

  @override
  _BreweryViewState createState() => new _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {

  Future _breweryFuture;
  
  @override
  void initState() {
    super.initState();
    _breweryFuture = WordpressAPI.getBrewery(widget.breweryId.toString());
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
          case ConnectionState.waiting: return AsyncLoader();
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
