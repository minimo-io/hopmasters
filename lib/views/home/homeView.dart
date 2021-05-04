import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/helpers.dart';
import 'package:hopmasters/models/brewery.dart';

import 'package:hopmasters/components/beer_cards.dart';
import 'package:hopmasters/components/breweries_cards.dart';
import 'package:hopmasters/views/home/components/bannerBreweries.dart';
import 'package:hopmasters/views/home/components/specialOffers.dart';
import 'package:hopmasters/views/home/components/discover_beers_header.dart';
import 'package:hopmasters/components/app_title.dart';
import 'package:hopmasters/components/search_bar.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future _breweryBeers;

  @override
  void initState() {
    super.initState();
    _breweryBeers = Helpers.getBeersFromBreweryID("89107");
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: Column(
            children: [
              SearchBar(),
              BreweriesBanner(),
              SizedBox(height: (20)),
              SpecialOffers(),
              SizedBox(height: (10)),
              DiscoverBeersHeader(),
              FutureBuilder(
                  future: _breweryBeers,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center( child: CircularProgressIndicator() );
                      default:
                        if (snapshot.hasError){
                          return Text('Ups! Error: ${snapshot.error}');
                        }else{
                          return BeerCards(beersList: snapshot.data);
                        }
                    }
                  }
              ),
              SizedBox(height: (30)),
              AppTitle(title: Text("Cervecerías")),
              BreweriesCards(),
              SizedBox(height: (100)),
            ],
          ),
        ),
      ),
    );
  }
}