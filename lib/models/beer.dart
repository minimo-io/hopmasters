import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class Beer{
  Beer({
    @required this.beerId,
    @required this.name,
    @required this.image,
    @required this.abv,
    @required this.ibu,
    @required this.launch,
    @required this.price,
    @required this.description,
    @required this.followers,
    @required this.breweryId,
    @required this.breweryName,
    @required this.breweryImage,
    @required this.type,
    @required this.size,

  });

  factory Beer.fromJson(Map<String, dynamic> parsedJson){
    return Beer(
      beerId: parsedJson['id'].toString(),
      name: parsedJson['name'].toString(),
      image: parsedJson['featured_image'].toString(),
      abv: "5",
      ibu: "50",
      launch: "2012",
      price: parsedJson['price'].toString(),
      description: parsedJson['short_description'].toString(),
      followers: "121",
      breweryId: "000",
      breweryName: "Malafama",
      breweryImage: "https://hops.uy/wp-content/uploads/2021/03/cerveceria-malafama-logo.png",
      type: "IPA",
      size: "500mL"
    );
  }

  String beerId;
  String name;
  String image;
  String abv;
  String ibu;
  String launch;
  String price;
  String description;
  String followers;
  String type;
  String size;

  String breweryId, breweryName, breweryImage;
}