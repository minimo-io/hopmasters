import 'package:flutter/cupertino.dart';
import 'package:Hops/models/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedServices{
  static Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  static Future<LoginResponse> loginDetails()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? LoginResponse.fromJson(jsonDecode(prefs.getString("login_details"))) : null;
  }

  static Future<void> setLoginDetails(LoginResponse loginResponseModel)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_details", loginResponseModel != null ? jsonEncode(loginResponseModel.toJson()) : null );

  }

  static Future<void> logout(BuildContext context) async{
    await setLoginDetails(null);
    Navigator.of(context).pushReplacementNamed("/login");
  }
}