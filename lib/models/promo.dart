import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';


class Promo {

  Promo({
    required this.id,
    required this.avatar,
    required this.name,
    required this.bgColor,
    required this.description,
    this.channelType,
    this.promoType,
    this.pointsScore,
    this.dateLimit,
    this.callToActionText,
    this.callToActionIcon,
    this.productAssociated,
    /*
    required this.scoreAvg,
    required this.scoreCount,
     */
  }) : this.rgbColor = Helpers.HexToColor(bgColor ?? Color.fromRGBO(234, 186, 0, 0.6) as String);

  factory Promo.fromJson(Map<String, dynamic> parsedJson){
    /*
    String? scoreAvg, scoreCount;
    if (parsedJson.containsKey("scores")){
      scoreAvg = parsedJson["scores"]["opinionScore"].toString();
      scoreCount = parsedJson["scores"]["opinionCount"].toString();
    }
    */
    String callToActionBtnText = parsedJson['acf']['call_to_action_button_text'];
    if (callToActionBtnText == "") callToActionBtnText = "Comprar";

    String callToActionBtnIconCode = parsedJson['acf']['call_to_action_button_icon'];

    IconData callToActionBtnIcon = Icons.shopping_cart;
    if (callToActionBtnIconCode == "qr_code_scanner"){
      callToActionBtnIcon = Icons.qr_code_scanner;
    }else if(callToActionBtnIconCode == "share"){
      callToActionBtnIcon = Icons.share;
    }else{
      callToActionBtnIcon = Icons.shopping_cart;
    }

    String? productAssociated = "0";
    if (parsedJson.containsKey("acf")
      && (parsedJson['acf']["product_associated"] != null )
    ){
      productAssociated = parsedJson['acf']["product_associated"].toString();
    }


    return Promo(
      id: parsedJson["id"].toString(),
      avatar: parsedJson["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"] ?? "",
      bgColor: parsedJson['acf']['bg_color'],
      name: parsedJson['title']['rendered'],
      description: parsedJson['excerpt']['rendered'],
      channelType: parsedJson['acf']['channel_type'],
      promoType: parsedJson['acf']['type'],
      pointsScore: parsedJson['acf']['points_score'],
      dateLimit: parsedJson['acf']['date_limit'],
      callToActionText: callToActionBtnText,
      callToActionIcon: callToActionBtnIcon,
      productAssociated: productAssociated,

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
  String? bgColor; // this is a string representing the ACF Hex color like '#CCCCCC'
  String? description;
  Color rgbColor; // this is a Color object
  String? channelType;
  String? promoType;
  String? pointsScore;
  String? dateLimit;
  String? callToActionText;
  IconData? callToActionIcon;
  String? productAssociated;
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
