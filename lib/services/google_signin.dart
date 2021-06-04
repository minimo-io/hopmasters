import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import '../secrets.dart';
import 'package:Hops/utils/notifications.dart';


class Google{
  GoogleSignIn _googleSignIn;

  Google(){
    this._googleSignIn = GoogleSignIn(
      clientId: GOOGLE_CLIENTID,
      scopes: <String>[
        'email',
        //'https://www.googleapis.com/auth/contacts.readonly',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );
  }

  Future<GoogleSignInAccount> login(context) async {
    var notificationsClient = new HopsNotifications();
    GoogleSignInAccount googleUser = null;
    try {
      final googleUser = await this._googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      return googleUser;
    } catch (error) {
      print(error);
    }
    return googleUser;
  }


  Future<void> logout() => this._googleSignIn.disconnect();




}
