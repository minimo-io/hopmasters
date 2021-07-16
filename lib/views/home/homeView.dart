import 'package:flutter/material.dart';

import 'dart:async';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/beer_cards.dart';
import 'package:Hops/components/breweries_cards.dart';
import 'package:Hops/components/app_title.dart';
import 'package:Hops/components/search_bar.dart';

import 'package:Hops/views/home/components/bannerBreweries.dart';
import 'package:Hops/views/home/components/specialOffers.dart';
import 'package:Hops/views/home/components/discoverBeers.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future? _breweryBeers;

  @override
  void initState() {
    super.initState();
    //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(),
              //BreweriesBanner(),
              SizedBox(height: (20)),
              SpecialOffers(),
              SizedBox(height: (30)),


              //SizedBox(height: (30)),

              DiscoverBeers(),

              SizedBox(height: (30)),

              AppTitle(title: "Top 10 cervecerías"),
              SizedBox(height: (5)),
              AppTitle(subtitle: "Las cervecerías mas seguidas por los usuarios."),
              SizedBox(height: (15.0)),
              BreweriesCards(),

              SizedBox(height: (100)),
            ],
          ),
        ),
      ),
    );
  }
}