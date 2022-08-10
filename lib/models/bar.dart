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
    required this.isFeatured,
    /*
    required this.scoreAvg,
    required this.scoreCount,
     */
  }) : this.rgbColor = Helpers.HexToColor(
            bgColor ?? Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Bar.fromJson(Map<String, dynamic> parsedJson) {
    /*
    String? scoreAvg, scoreCount;
    if (parsedJson.containsKey("scores")){
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }
    */
    return Bar(
      id: parsedJson["id"].toString(),
      avatar: parsedJson["_embedded"]["wp:featuredmedia"][0]["media_details"]
              ["sizes"]["thumbnail"]["source_url"] ??
          "",
      latitude: parsedJson['acf']['latitude'],
      longitude: parsedJson['acf']['longitude'],
      address: parsedJson['acf']['address_name'],
      whatsapp: parsedJson['acf']['whatsapp'],
      bgColor: parsedJson['acf']['bg_color'],
      name: parsedJson['title']['rendered'],
      description: parsedJson['excerpt']['rendered'],
      isFeatured: parsedJson['acf']['is_featured'],
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
  String?
      bgColor; // this is a string representing the ACF Hex color like '#CCCCCC'
  String? description;
  Color rgbColor; // this is a Color object
  bool isFeatured;
}
