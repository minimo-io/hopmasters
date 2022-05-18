import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';


class Bar {

  Bar({
    required this.id,
    required this.avatar,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.whatsapp,
    required this.bgColor,
    required this.description,
    /*
    required this.scoreAvg,
    required this.scoreCount,
     */
  }) : this.rgbColor = Helpers.HexToColor(bgColor ?? Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Bar.fromJson(Map<String, dynamic> parsedJson){
    /*
    String? scoreAvg, scoreCount;
    if (parsedJson.containsKey("scores")){
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }
    */
    return Bar(
        id: parsedJson["id"].toString(),
        avatar: parsedJson["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"] ?? "",
        latitude: parsedJson['acf']['latitude'],
        longitude: parsedJson['acf']['longitude'],
        address: parsedJson['acf']['address_name'],
        whatsapp: parsedJson['acf']['whatsapp'],
        bgColor: parsedJson['acf']['bg_color'],
        name: parsedJson['title']['rendered'],
        description: parsedJson['excerpt']['rendered'],
        /*
        scoreAvg: scoreAvg,
        scoreCount: scoreCount,
         */
        //comment: parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"][0]) : null // passing only the first one (as user can edit)
    );
  }

  String id;
  String? avatar;
  String? name;
  String? latitude;
  String? longitude;
  String? address;
  String? whatsapp;
  String? followers;
  String? bgColor; // this is a string representing the ACF Hex color like '#CCCCCC'
  String? description;
  Color rgbColor; // this is a Color object
  //String? scoreAvg;
  //String? scoreCount;
  //Comment? comment;
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