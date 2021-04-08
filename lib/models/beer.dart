import 'package:flutter/material.dart';
import 'package:hopmasters/helpers.dart';
import 'dart:convert';
import 'package:meta/meta.dart';


class Beer{
  Beer({
    @required this.name,
    @required this.image,
    @required this.abv,
    @required this.description,
    @required this.followers
  });

  String name;
  String image;
  String abv;
  String description;
  String followers;

}