import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/brewery.dart';

class Promo {
  Promo({
    required this.id,
    required this.avatar,
    required this.name,
    this.nameShort,
    this.minBuy,
    this.discountValue = 0.0,
    required this.bgColor,
    required this.description,
    this.channelType,
    this.promoType,
    this.pointsScore,
    this.dateLimit,
    this.callToActionText,
    this.callToActionIcon,
    this.productAssociated,
    this.breweryAssociated,
    /*
    required this.scoreAvg,
    required this.scoreCount,
     */
  }) : this.rgbColor = Helpers.HexToColor(
            bgColor ?? Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Promo.fromJson(Map<String, dynamic> parsedJson) {
    /*
    String? scoreAvg, scoreCount;
    if (parsedJson.containsKey("scores")){
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }
    */

    String callToActionBtnText = parsedJson['data']['callToActionText'];
    if (callToActionBtnText == "") callToActionBtnText = "Comprar";

    String callToActionBtnIconCode = parsedJson['data']['callToActionIcon'];

    IconData callToActionBtnIcon = Icons.shopping_cart;
    if (callToActionBtnIconCode == "qr_code_scanner") {
      callToActionBtnIcon = Icons.qr_code_scanner;
    } else if (callToActionBtnIconCode == "share") {
      callToActionBtnIcon = Icons.share;
    } else {
      callToActionBtnIcon = Icons.shopping_cart;
    }

    String? productAssociated = "0";
    if (parsedJson.containsKey("data") &&
        (parsedJson['data']["productAssociated"] != null)) {
      productAssociated = parsedJson['data']["productAssociated"].toString();
    }

    Brewery? breweryAssociated;

    if (parsedJson.containsKey("data") &&
        (parsedJson['data']["breweryAssociated"] != null)) {
      breweryAssociated =
          Brewery.fromJson(parsedJson['data']["breweryAssociated"]);
    }

    int minBuy = 0;
    if (parsedJson.containsKey("data") &&
        (parsedJson['data']["minBuy"] != null)) {
      minBuy = int.parse(parsedJson['data']["minBuy"]);
    }
    double discountValue = 0.0;
    if (parsedJson.containsKey("data") &&
        (parsedJson['data']["discountValue"] != null)) {
      discountValue = double.parse(parsedJson['data']["discountValue"]);
    }

    return Promo(
      id: parsedJson["data"]["id"].toString(),
      avatar: parsedJson["data"]["avatar"],
      bgColor: parsedJson['data']['bgColor'],
      name: parsedJson['data']['name'],
      description: parsedJson['data']['description'],
      channelType: parsedJson['data']['channelType'],
      promoType: parsedJson['data']['promoType'],
      pointsScore: parsedJson['data']['pointsScore'],
      dateLimit: parsedJson['data']['dateLimit'],
      nameShort: parsedJson['data']['nameShort'],
      minBuy: minBuy,
      discountValue: discountValue,
      callToActionText: callToActionBtnText,
      callToActionIcon: callToActionBtnIcon,
      productAssociated: productAssociated,
      breweryAssociated: breweryAssociated,

      /*
      barAssociated: parsedJson['acf']['bar_associated'],
      productAssociated: parsedJson['acf']['bar_associated'],

       */
      /*
        scoreAvg: scoreAvg,
        scoreCount: scoreCount,
         */
      //comment: parsedJson["user_comment"].length > 0 ? new Comment.fromJson(parsedJson["user_comment"][0]) : null // passing only the first one (as user can edit)
    );
  }

  static List<Promo> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Promo.fromJson(obj))
        .toList()
        .cast<Promo>();
  }

  String id;
  String? avatar;
  String? name;
  String? nameShort;
  int? minBuy;
  double discountValue;
  String?
      bgColor; // this is a string representing the ACF Hex color like #CCCCCC
  String? description;
  Color rgbColor; // this is a Color object
  String? channelType;
  String? promoType;
  String? pointsScore;
  String? dateLimit;
  String? callToActionText;
  IconData? callToActionIcon;
  String? productAssociated;
  Brewery? breweryAssociated;
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
