import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:Hops/models/login.dart';
import 'package:Hops/models/brewery.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/brewery_details/components/footer/brewery_showcase.dart';
import 'package:Hops/views/brewery_details/components/brewery_detail_body.dart';
import 'package:Hops/views/brewery_details/components/header/brewery_detail_header.dart';


class BreweryView extends StatefulWidget {
  static const routeName = "/brewery";

  final Object? breweryId;

  BreweryView({ this.breweryId });

  @override
  _BreweryViewState createState() => new _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
      future: Future.wait([
        WordpressAPI.getBrewery(widget.breweryId.toString()),
        SharedServices.loginDetails()
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return AsyncLoader();
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else

              return Scaffold(
                body: new SingleChildScrollView(
                  child: new Container(
                    decoration: linearGradient,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new BreweryDetailHeader(
                            snapshot.data?[0],
                            avatarTag: "brewery-" +
                                widget.breweryId.toString(),
                            userData: snapshot.data?[1]
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: new BreweryDetailBody(
                              snapshot.data?[0]),
                        ),
                        new BreweryShowcase(snapshot.data?[0]),
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
