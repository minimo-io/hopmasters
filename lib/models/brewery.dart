import 'package:flutter/material.dart';
import 'package:hopmasters/helpers.dart';
import 'dart:convert';
import 'package:meta/meta.dart';

class Brewery {

  Brewery({
    @required this.id,
    @required this.avatar,
    @required this.name,
    @required this.location,
    @required this.followers,
    @required this.beersCount,
    @required this.bgColor,
    @required this.description
  }) : this.rgbColor = Helpers.HexToColor(bgColor ?? Color.fromRGBO(234, 186, 0, 0.6));

  String id;
  String avatar;
  String name;
  String location;
  String followers;
  String beersCount;
  String bgColor; // this is a string representing the ACF Hex color like '#CCCCCC'
  String description;
  Color rgbColor; // this is a Color object

  /*
  static List<Brewery> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Brewery.fromMap(obj))
        .toList()
        .cast<Brewery>();
  }

  static Brewery fromMap(Map map) {
    var name = map['name'];

    return new Brewery(
      avatar: map['picture']['large'],
      name: '${_capitalize(name['first'])} ${_capitalize(name['last'])}',
      followers: map['followers'],
      beersCount: map['beers_count'],
      bgColor: map['bg_color'],
      description: map['description'],
      location: _capitalize(map['location']['state']),
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
  */

}
