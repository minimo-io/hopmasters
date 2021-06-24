import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/comment.dart';



class Beer{
  Beer({
    required this.beerId,
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
    required this.bgColor,
    required this.type,
    required this.size,
    this.comment

  }) : this.rgbColor = Helpers.HexToColor(bgColor ?? "#ffffff");

  factory Beer.fromJson(Map<String, dynamic> parsedJson){
    String? beerImage;
    if (parsedJson['featured_image'] != null) beerImage = parsedJson['featured_image'];
    if (beerImage == null) beerImage = parsedJson['images'][0]['src'].toString(); // must be the other endpoint result

    String? bgColor;
    if (parsedJson['bg_color'] != null) bgColor = parsedJson['bg_color'];
    if (bgColor == null) bgColor = parsedJson['acf']["bg_color"].toString(); // must be the other endpoint result

    String? followers = "0";
    if (parsedJson.containsKey("acf")) followers = parsedJson['acf']["followers"].toString();

    String? abv = "0";
    if (parsedJson.containsKey("acf")) abv = parsedJson['acf']["abv"].toString();

    String? ibu = "0";
    if (parsedJson.containsKey("acf")) ibu = parsedJson['acf']["ibu"].toString();

    String? launch = "0";
    if (parsedJson.containsKey("acf")) launch = parsedJson['acf']["launch"].toString();

    String? type = "Desconocido";
    if (parsedJson.containsKey("categories") && parsedJson['categories'][0] != null){
      type = parsedJson['categories'][0]["name"].toString();
      if (parsedJson['categories'].asMap().containsKey(1)) {
        type = parsedJson['categories'][1]["name"].toString();
      }
    }

    String? breweryId, breweryName, breweryImage;
    String? container;
    if (parsedJson.containsKey("acf")){
      breweryId = parsedJson['acf']['brewery']['ID'].toString();
      breweryName = parsedJson['acf']['brewery']['post_title'];
      breweryImage = parsedJson['acf']['brewery_image'];

      container = parsedJson['acf']['container'];
    }


    if (parsedJson.containsKey("user_comment")){
      // parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"]) : null;
    }

    return Beer(
      beerId: parsedJson['id'].toString(),
      name: parsedJson['name'].toString(),
      image: beerImage,
      abv: abv + "%",
      ibu: ibu,
      launch: launch,
      price: parsedJson['price'].toString(),
      description: parsedJson['short_description'].toString(),
      bgColor: bgColor,
      followers: followers,
      breweryId: breweryId,
      breweryName: breweryName,
      breweryImage: breweryImage,
      type: type,
      size: container,
      comment:parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"]) : null
    );
  }

  String beerId;
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
  String? bgColor; // this is a string representing the ACF Hex color like '#CCCCCC', like its returned from the back-end
  Color rgbColor;
  Comment? comment;

  String? breweryId, breweryName, breweryImage;
}