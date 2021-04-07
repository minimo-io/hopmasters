import 'package:flutter/material.dart';
import 'package:hopmasters/models/brewery.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/components/beer_cards.dart';
import 'package:hopmasters/views/home/components/bannerBreweries.dart';
import 'package:hopmasters/views/home/components/specialOffers.dart';
import 'package:hopmasters/views/home/components/discover_beers_header.dart';
import 'package:hopmasters/components/search_bar.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  dynamic _beers = "";

  @override
  void initState(){
    super.initState();
    _loadBeers();
  }

  Future<void> _loadBeers() async {
    http.Response response =  await http.get(WP_BASE_API + "/wp-json/wp/v2/posts?_embed", headers: {
    'Accept': 'application/json'
    });
    final responseJson = jsonDecode(response.body);
    setState(() {
      _beers = responseJson;
    });
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
              BeerCards(),
              SizedBox(height: (30)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/brewery",
                    arguments: { 'breweryId': 89059 },

                  );
                }, // handle your image tap here
                child: Hero(
                  tag: "brewery-89059",
                  child: Image.network(
                    'https://i2.wp.com/hopmasters.net/wp-content/uploads/2021/03/cerveceria-malafama-logo.png?resize=150%2C150&ssl=1',
                    fit: BoxFit.cover, // this is the solution for border
                    width: 110.0,
                    height: 110.0,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: new BorderRadius.circular(30.0),
                child: new OutlineButton.icon(
                  icon: Icon(Icons.sports_bar),
                  onPressed: () {


                    Navigator.pushNamed(
                      context,
                      "/brewery",
                      arguments: { 'breweryId': 89059 },

                    );
                  },
                  label: new Text("Malafama"),
                ),
              ),
              SizedBox(height: (30)),
              Text(_beers.toString()),
              SizedBox(height: (3000)),
            ],
          ),
        ),
      ),
    );
  }
}