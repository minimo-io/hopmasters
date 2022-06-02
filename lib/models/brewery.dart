import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/comment.dart';

class Brewery {
  Brewery({
    required this.id,
    required this.name,
    required this.description,
    required this.datePublished,
    required this.dateModified,
    required this.location,
    required this.followers,
    required this.bgColor,
    required this.scoreAvg,
    required this.scoreCount,
    required this.beersCount,
    required this.image,
    required this.url,
    required this.instagram,
    required this.whatsapp,
    required this.viewsCount,
    required this.viewsCountHistory,
    this.comment,
  }) : this.rgbColor = Helpers.HexToColor(
            bgColor ?? const Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Brewery.fromJson(Map<String, dynamic> parsedJson) {
    String? scoreAvg, scoreCount;

    if (parsedJson.containsKey("scores")) {
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }

    return Brewery(
        id: parsedJson['brewery']["id"].toString(),
        name: parsedJson['brewery']['name'].toString(),
        description: parsedJson['brewery']['description'],
        datePublished: parsedJson['brewery']['date_published'],
        dateModified: parsedJson['brewery']['date_modified'],
        location: parsedJson['brewery']['location'],
        followers: parsedJson['brewery']['followers'],
        beersCount: parsedJson['brewery']['beers_count'],
        bgColor: parsedJson['brewery']['bg_color'],
        url: parsedJson['brewery']['brewery_url'],
        instagram: parsedJson['brewery']['brewery_instagram'],
        whatsapp: parsedJson['brewery']['whatsapp'],
        scoreAvg: scoreAvg,
        scoreCount: scoreCount,
        viewsCount: parsedJson['brewery']['views_count'],
        viewsCountHistory: parsedJson['brewery']['views_count_history'],
        image: parsedJson['brewery']['image'],
        comment: parsedJson["user_comment"].length > 0
            ? Comment.fromJson(parsedJson["user_comment"][0])
            : null // passing only the first one (as user can edit)
        );
  }

  String id;
  String image;
  String? name;
  String? location;
  String? followers;
  String? beersCount;
  String?
      bgColor; // this is a string representing the ACF Hex color like '#CCCCCC'
  String? description;
  Color rgbColor; // this is a Color object
  String? scoreAvg;
  String? scoreCount;
  Comment? comment;

  String datePublished;
  String dateModified;

  String url;
  String instagram;
  String whatsapp;
  String viewsCount;
  String viewsCountHistory;
}
