import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:location/location.dart';

class Helpers {
  // convert an html like hex color #FFFFFF to Color Widget
  static Color HexToColor(String HexColor) {
    if (HexColor.length == 6 || HexColor.length == 7)
      HexColor = 'ff' + HexColor;
    HexColor = HexColor.replaceFirst('#', '');
    return Color(int.parse(HexColor, radix: 16));
  }

  //here goes the function
  static String parseHtmlString(String? htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static launchURL(String url) async {
    Uri uri = Uri.parse(url);
    print("This is an url");
    print(uri.runtimeType);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  static double screenAwareSize(double size, BuildContext context) {
    //double baseHeight = 640.0;
    //return size * MediaQuery.of(context).size.height / baseHeight;
    return size;
  }

  static double getTopSafeArea(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;
    safePadding = safePadding - 15;

    return safePadding;
  }

  static Future<String> buildVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return "v." + version.toString() + " / build " + buildNumber;
  }

  static void userAskedForHelp() {
    launchURL("https://wa.me/59896666902");
  }

  static Future<LocationData?>? _getLocationData(Location location) async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    return _locationData;
  }

  static Future<LocationData?>? askForLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
