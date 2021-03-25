import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';


// The almighty beer class
class Beer{
  final String name, type, image;
  final num abv, price;

  const Beer({this.name, this.type, this.image, this.abv, this.price});
}