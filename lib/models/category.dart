import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:meta/meta.dart';

class Category {
  int? id;
  String? name;
  String? slug;
  int? parent;
  String? description;
  String? display;
  String? image;
  int? menu_order;
  int? count;


  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    required this.image,
    required this.menu_order,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> parsedJson){
    return Category(
      id: parsedJson["id"],
      name: parsedJson["name"],
      slug: parsedJson["slug"],
      parent: parsedJson["parent"],
      description: parsedJson["description"],
      display: parsedJson["display"],
      image: parsedJson["image"],
      menu_order: parsedJson["menu_order"],
      count: parsedJson["count"]

    );
  }

  static List<Category> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Category.fromJson(obj))
        .toList()
        .cast<Category>();
  }


}
