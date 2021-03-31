import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/components/beer_cards.dart';
import 'package:hopmasters/views/home/components/bannerBreweries.dart';
import 'package:hopmasters/views/home/components/specialOffers.dart';
import 'package:hopmasters/views/home/components/discover_beers_header.dart';


class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

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
              BreweriesBanner(),
              SizedBox(height: (10)),
              SpecialOffers(),
              SizedBox(height: (10)),
              DiscoverBeersHeader(),
              BeerCards(),
              SizedBox(height: (30)),
              SizedBox(height: (3000)),
            ],
          ),
        ),
      ),
    );
  }
}