import 'package:flutter/material.dart';
import 'package:hopmasters/helpers.dart';
import 'dart:convert';
import 'package:meta/meta.dart';


class Beer{
  Beer({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.abv,
    @required this.ibu,
    @required this.launch,
    @required this.price,
    @required this.description,
    @required this.followers,
    @required this.breweryId,
    @required this.breweryName,
    @required this.breweryImage,
    @required this.type,
    @required this.size,

  });

  String id;
  String name;
  String image;
  String abv;
  String ibu;
  String launch;
  String price;
  String description;
  String followers;
  String type;
  String size;

  String breweryId, breweryName, breweryImage;
}