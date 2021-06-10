import 'package:flutter/cupertino.dart';
import 'package:Hops/models/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
}