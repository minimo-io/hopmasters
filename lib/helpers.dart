import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers{
  // convert an html like hex color #FFFFFF to Color Widget
  static Color HexToColor(String HexColor){
    if (HexColor.length == 6 || HexColor.length == 7) HexColor = 'ff' + HexColor;
    HexColor = HexColor.replaceFirst('#', '');
    return Color(int.parse(HexColor, radix: 16));
  }

  //here goes the function
  static String parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }


  static double screenAwareSize(double size, BuildContext context) {
    double baseHeight = 640.0;
    //return size * MediaQuery.of(context).size.height / baseHeight;
    return size;
  }


  static double getTopSafeArea(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    safePadding = safePadding - 15;

    return safePadding;
  }


}