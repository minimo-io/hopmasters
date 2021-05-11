import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hopmasters/constants.dart';

class Helpers{
  // convert an html like hex color #FFFFFF to Color Widget
  static Color HexToColor(String HexColor){
    if (HexColor.length == 6 || HexColor.length == 7) HexColor = 'ff' + HexColor;
    HexColor = HexColor.replaceFirst('#', '');
    return Color(int.parse(HexColor, radix: 16));
  }

  //here goes the function
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static Future getBeersFromBreweryID(String breweryID)async{
    final String beersFromBreweryUriQuery = WP_BASE_API + WP_REST_HOPS_VERSION_URI + "beers/breweryID/"+ breweryID +"?_embed";
    //print(beersFromBreweryUriQuery);
    final response = await http.get(beersFromBreweryUriQuery,
        headers: { 'Accept': 'application/json' });
    if (response.statusCode == 200){

      var jsonResponse = json.decode(response.body);

      return jsonResponse;


    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load beers.');
    }
  }


  static launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

}