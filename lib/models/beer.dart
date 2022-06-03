import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/comment.dart';
import 'package:Hops/models/store.dart';
import 'package:Hops/models/brewery.dart';

class Beer {
  Beer(
      {required this.beerId,
      required this.name,
      required this.image,
      required this.abv,
      required this.ibu,
      required this.launch,
      required this.price,
      required this.description,
      required this.followers,
      required this.breweryId,
      required this.breweryName,
      required this.breweryImage,
      required this.breweryWhatsapp,
      required this.bgColor,
      required this.type,
      required this.size,
      required this.stockStatus,
      required this.scoreAvg,
      required this.scoreCount,
      required this.brewery,
      this.comment,
      this.stores})
      : this.rgbColor = Helpers.HexToColor(bgColor ?? "#ffffff");

  factory Beer.fromJson(Map<String, dynamic> parsedJson) {
    String? beerImage;
    if (parsedJson['featured_image'] != null)
      beerImage = parsedJson['featured_image'];
    if (beerImage == null)
      beerImage = parsedJson['images'][0]['src']
          .toString(); // must be the other endpoint result

    String? bgColor;
    if (parsedJson['bg_color'] != null) bgColor = parsedJson['bg_color'];
    if (bgColor == null)
      bgColor = parsedJson['acf']["bg_color"]
          .toString(); // must be the other endpoint result

    String? followers = "0";
    if (parsedJson.containsKey("acf"))
      followers = parsedJson['acf']["followers"].toString();

    String? abv = "0";
    if (parsedJson.containsKey("acf"))
      abv = parsedJson['acf']["abv"].toString();

    String? ibu = "N/A";
    if (parsedJson.containsKey("acf"))
      ibu = (parsedJson['acf']["ibu"].toString() == "0"
          ? "N/A"
          : parsedJson['acf']["ibu"].toString());

    String? launch = "0";
    if (parsedJson.containsKey("acf"))
      launch = parsedJson['acf']["launch"].toString();

    String? type = "Desconocido";
    if (parsedJson.containsKey("categories") &&
        parsedJson['categories'][0] != null) {
      type = parsedJson['categories'][0]["name"].toString();
      if (parsedJson['categories'].asMap().containsKey(1)) {
        type = parsedJson['categories'][1]["name"].toString();
      }
    }

    String? breweryId, breweryName, breweryImage;
    String? container;
    if (parsedJson.containsKey("acf")) {
      breweryId = parsedJson['acf']['brewery']['ID'].toString();
      breweryName = parsedJson['acf']['brewery']['post_title'];
      breweryImage = parsedJson['acf']['brewery_image'];

      container = parsedJson['acf']['container'];
    }

    String stockStatus = "";
    if (parsedJson.containsKey("stock_status")) {
      // parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"]) : null;
      stockStatus = parsedJson['stock_status'].toString();
    }

    if (parsedJson.containsKey("user_comment")) {
      // parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"]) : null;
    }

    String? scoreAvg, scoreCount;
    if (parsedJson.containsKey("scores")) {
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }

    List stores = [];
    if (parsedJson.containsKey("stores")) {
      // parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"]) : null;
      stores = parsedJson["stores"];
    }

    // build brewery object
    Brewery brewery = Brewery.fromJson(parsedJson["brewery"]);

    return Beer(
        beerId: parsedJson['id'].toString(),
        brewery: brewery,
        name: parsedJson['name'].toString(),
        image: beerImage,
        abv: abv + "%",
        ibu: ibu,
        launch: launch,
        price: parsedJson['price'].toString(),
        description: parsedJson['short_description'].toString(),
        bgColor: bgColor,
        followers: followers,
        breweryId: brewery.id,
        breweryName: brewery.name,
        breweryImage: brewery.image,
        breweryWhatsapp: brewery.whatsapp,
        type: type,
        size: container,
        stockStatus: stockStatus,
        scoreAvg: scoreAvg,
        scoreCount: scoreCount,
        stores: stores.isNotEmpty ? Store.allFromResponse(stores) : null,
        comment: parsedJson["user_comment"].length > 0
            ? Comment.fromJson(parsedJson["user_comment"][0])
            : null // passing only the first one (as user can edit)
        );
  }

  String beerId;
  Brewery brewery;
  String? name;
  String? image;
  String? abv;
  String? ibu;
  String? launch;
  String? price;
  String description;
  String? followers;
  String? type;
  String? size;
  String?
      bgColor; // this is a string representing the ACF Hex color like '#CCCCCC', like its returned from the back-end
  Color rgbColor;
  Comment? comment;
  String? scoreAvg;
  String? scoreCount;
  String stockStatus;
  String? breweryId, breweryName, breweryImage, breweryWhatsapp;
  List? stores;
}
