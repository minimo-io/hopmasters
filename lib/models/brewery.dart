import 'package:Hops/models/promo.dart';
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
    this.deliveryCost,
    this.deliveryMin,
    this.deliveryTime,
    this.comment,
    this.promos,
  }) : this.rgbColor = Helpers.HexToColor(
            bgColor ?? const Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Brewery.fromJson(Map<String, dynamic> parsedJson) {
    String? scoreAvg, scoreCount;

    if (parsedJson.containsKey("scores")) {
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }

    Map<String, dynamic> baseJson = parsedJson;
    if (parsedJson.containsKey("brewery")) {
      baseJson = parsedJson["brewery"];
    }

    if (parsedJson.containsKey("score_avg")) {
      scoreAvg = parsedJson["score_avg"].toString();
    }
    if (parsedJson.containsKey("score_count")) {
      scoreCount = parsedJson["score_count"].toString();
    }

    List<Promo>? promos;

    if (baseJson.containsKey("promos") && baseJson["promos"] != null) {
      promos = Promo.allFromResponse(baseJson["promos"]);
    }

    return Brewery(
        id: baseJson["id"].toString(),
        name: baseJson['name'].toString(),
        description: baseJson['description'],
        datePublished: baseJson['date_published'],
        dateModified: baseJson['date_modified'],
        location: baseJson['location'],
        followers: baseJson['followers'],
        beersCount: baseJson['beers_count'],
        bgColor: baseJson['bg_color'],
        url: baseJson['brewery_url'],
        instagram: baseJson['brewery_instagram'],
        whatsapp: baseJson['whatsapp'],
        scoreAvg: scoreAvg,
        scoreCount: scoreCount,
        viewsCount: baseJson['views_count'],
        viewsCountHistory: baseJson['views_count_history'],
        image: baseJson['image'],
        promos: promos,
        deliveryCost: double.parse(baseJson['delivery_cost'].toString()),
        deliveryMin: int.parse(baseJson['delivery_min'].toString()),
        deliveryTime: baseJson['delivery_time'],
        comment: parsedJson.containsKey("user_comment") &&
                parsedJson["user_comment"].length > 0
            ? Comment.fromJson(parsedJson["user_comment"][0])
            : null // passing only the first one (as user can edit)
        );
  }

  String id;
  String image;
  String name;
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
  List<Promo>? promos;

  int? deliveryMin;
  double? deliveryCost;
  String? deliveryTime;
}
