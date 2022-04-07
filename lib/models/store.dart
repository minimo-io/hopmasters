import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

class Store{
  String? id;
  String? name;
  String? price;
  String? priceLastUpdate;
  String? url;
  String? image;
  String? isVerified;


  Store({
    this.id,
    this.name,
    this.price,
    this.priceLastUpdate,
    this.url,
    this.image,
    this.isVerified,
  });

  Store.fromJson(Map<String, dynamic> parsedJson){

    id = (parsedJson["id"] != null ? parsedJson["id"] : "" );
    name = (parsedJson["name"] != null ? parsedJson["name"] : "" );
    price = (parsedJson["price"] != null ? parsedJson["price"] : "" );
    priceLastUpdate = (parsedJson["price_last_update"] != null ? parsedJson["price_last_update"] : "" );
    url = (parsedJson["url"] != null ? parsedJson["url"] : "" );
    image = (parsedJson["image"] != null ? parsedJson["image"] : "" );
    isVerified = (parsedJson["is_verified"] != null ? parsedJson["is_verified"] : "" );


  }


  static List? allFromResponse(List<dynamic> response) {

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Store.fromJson(obj))
        .toList()
        .cast<Store>();
  }



}