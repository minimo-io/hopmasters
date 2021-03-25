import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';


// The almighty beer class
class Beer{
  final String name, type, image;
  final num abv, price;

  const Beer({this.name, this.type, this.image, this.abv, this.price});
}


class BeerGridTile extends StatelessWidget {
  final String name, image, type;
  final num price;

  const BeerGridTile({this.name, this.image, this.type, this.price});


  @override
  Widget build(BuildContext context) {
    // return false;
  }
}