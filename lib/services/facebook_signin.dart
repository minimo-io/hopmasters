import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Facebook{
  Future<Map<String, dynamic>> login() async{
    /*
    final AccessToken accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      // user is logged for Facebook, so create the shared service
      // and proceed with login

    }
    */

    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],

    );

    // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      // you are logged
      //final AccessToken accessToken = result.accessToken;
      var resultJson = await FacebookAuth.instance.getUserData();
      return resultJson;
    }{
      return null;
    }


  }

  Future<void> logout(Function fn)async{
    await FacebookAuth.instance.logOut().then((value) => fn);
  }
}