import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';


// The almighty beer class
class Beer{
  final String? name, type, image;
  final num? abv, price;

  const Beer({
    this.name,
    this.type,
    this.image,
    this.abv,
    this.price
  });
}