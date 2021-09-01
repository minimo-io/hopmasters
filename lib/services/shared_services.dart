import 'dart:convert';
import 'dart:collection';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Hops/models/preferences.dart';
import 'package:Hops/models/order_data.dart';

class SharedServices{

  static Future<bool> isLoggedIn() async{
    final Sharedprefs = await SharedPreferences.getInstance();
    return Sharedprefs.getString("login_details") != '{}' && Sharedprefs.getString("login_details") != null
        ? true
        : false;
  }

  static Future<LoginResponse?> loginDetails()async{
    final Sharedprefs = await SharedPreferences.getInstance();
    return Sharedprefs.getString("login_details") != '{}' && Sharedprefs.getString("login_details") != null
        ? LoginResponse.fromJson(jsonDecode(Sharedprefs.getString("login_details")!))
        : null;
  }

  static Future<OrderData?> lastShippingDetails()async{
    final Sharedprefs = await SharedPreferences.getInstance();
/*
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('last_shipping_details');
    return null;
    var order = (jsonDecode(Sharedprefs.getString("last_shipping_details")!));

 */

    return Sharedprefs.getString("last_shipping_details") != '{}' && Sharedprefs.getString("last_shipping_details") != null
        //? OrderData.fromJson(jsonDecode(Sharedprefs.getString("last_shipping_details")!))
        ? OrderData.fromJson(jsonDecode(Sharedprefs.getString("last_shipping_details")!))
        : null;
  }
  static Future<void> setLastShippingDetails(OrderData? lastOrderData)async{
    final Sharedprefs = await SharedPreferences.getInstance();
    Sharedprefs.setString("last_shipping_details", lastOrderData != null ? jsonEncode(lastOrderData.toJson()) : "{}" );

  }

  static Future<void> setLoginDetails(LoginResponse? loginResponseModel)async{
    final Sharedprefs = await SharedPreferences.getInstance();

    Sharedprefs.setString("login_details", loginResponseModel != null ? jsonEncode(loginResponseModel.toJson()) : "{}" );
    // Sharedprefs.setString("login_details", loginResponseModel != null ? jsonEncode(loginResponseModel.toJson()) : "{}" );

  }

  static Future<void> logout(BuildContext context) async{
    final Sharedprefs = await SharedPreferences.getInstance();
    Sharedprefs.setString("login_details", '{}' );
    Navigator.of(context).pushReplacementNamed("login");
  }

  /// Save Preferences
  static Future<void> savePreferences(String preferenceType, UnmodifiableListView<Pref> prefList)async{
    final Sharedprefs = await SharedPreferences.getInstance();

    if (preferenceType == "beer_types") Sharedprefs.setString("beer_types", jsonEncode(prefList));
    if (preferenceType == "news_types") Sharedprefs.setString("news_types", jsonEncode(prefList));
  }
  /// Get Preferences
  static Future<List<dynamic>?> getPreferences(String preferenceType)async{
    final Sharedprefs = await SharedPreferences.getInstance();
    if (preferenceType == "beer_types"){
      return Sharedprefs.getString("beer_types") != '{}' && Sharedprefs.getString("beer_types") != null
          ? jsonDecode(Sharedprefs.getString("beer_types")!)
          : null;
    }
    if (preferenceType == "news_types"){
      return Sharedprefs.getString("news_types") != '{}' && Sharedprefs.getString("news_types") != null
          ? jsonDecode(Sharedprefs.getString("news_types")!)
          : null;
    }
    return null;
  }
  /// Load Preferences to Provider
  static Future<void> populateProvider(BuildContext context, String preferenceType)async{
    var preferences  = await Provider.of<Preferences>(context, listen: false);

    if (preferenceType == "beer_types"){
      var beerTypePrefs = await SharedServices.getPreferences("beer_types");
      if (beerTypePrefs != null){
        beerTypePrefs.forEach((element) {
          preferences.add(Pref.fromJson(element));
        });
      }

    }
    if (preferenceType == "news_types"){
      var newsPrefs = await SharedServices.getPreferences("news_types");
      if (newsPrefs != null){
        newsPrefs.forEach((element) {
          preferences.addNews(Pref.fromJson(element));
        });

      }

    }
    return null;
  }

}