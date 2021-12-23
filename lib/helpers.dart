import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:location/location.dart';

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

  static Future<String> buildVersionNumber()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return "v."+version.toString();

  }

  static Future<LocationData?>? _getLocationData(Location location)async{
    LocationData _locationData;
    _locationData = await location.getLocation();
    return _locationData;
  }
  static askForLocation()async{
    /*
    Location location = new Location();
    location.serviceEnabled().then((serviceEnabled){
      print("Service Enabled");
      print(serviceEnabled);

      if (!serviceEnabled) {
        location.requestService().then((serviceEnabled){
          if (!serviceEnabled) {
            print("Service NOT enabled");
            return false;
          }else{

            location.hasPermission().then((permissionGranted){
              if (permissionGranted == PermissionStatus.denied) {
                location.requestPermission().then((permissionGranted){
                  if (permissionGranted != PermissionStatus.granted) {
                    return false;
                  }else{

                    // get location
                    return _getLocationData(location);

                  }
                });

              }
            });


          }



        });

      }else{

        location.hasPermission().then((permissionGranted){
          print("Permission granted? 2");
          print(permissionGranted);
          if (permissionGranted == PermissionStatus.denied) {
            location.requestPermission().then((permissionGranted){

              if (permissionGranted != PermissionStatus.granted) {
                return false;
              }else{
                print("LOCATION DATA: ");
                return _getLocationData(location);
              }
            });

          }else{
            print("OK GRANTED! NOW LOCATION:");

            return _getLocationData(location);
          }
        });

      }
    });

     */

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;

  }

}