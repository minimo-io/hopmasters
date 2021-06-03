import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Facebook{
  Future<Map<String, dynamic>> login() async{
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],

    ); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken;
      FacebookAuth.instance.getUserData().then((userData){
        print(userData);
        return userData;
      });
    }{
      return null;
    }
  }

  Future<void> logout(Function fn)async{
    await FacebookAuth.instance.logOut().then((value) => fn);
  }
}