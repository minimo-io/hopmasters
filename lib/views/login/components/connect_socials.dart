import 'dart:math';
import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import '../../../secrets.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/services/google_signin.dart';

import 'package:Hops/views/login/components/top_logo.dart';
import 'package:Hops/views/login/mixins/gotos.mixin.dart';

import 'package:Hops/models/login.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/customer.dart';
import 'package:Hops/services/wordpress_api.dart';


class ConnectSocialsPage extends StatefulWidget {
  BoxDecoration headerDecoration;
  PageController controller;

  ConnectSocialsPage({
    this.headerDecoration,
    this.controller
  });

  @override
  _ConnectSocialsPageState createState() => _ConnectSocialsPageState();
}

class _ConnectSocialsPageState extends State<ConnectSocialsPage> with GotosMixin {
  final _formLoginKey = GlobalKey<FormState>();
  bool isLoadingApiCall = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  //var notificationsClient = new HopsNotifications();

  TextEditingController loginUsernameController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  // final FocusNode _loginUsernameFocusNode = FocusNode();
  // final FocusNode _loginPasswordFocusNode = FocusNode();

  static const _buttonsPaddingHorizontal = 25.0;
  static const _buttonsPaddingVertical = 13.0;
  static const _buttonsFontSize = 18.0;

  Widget _createButton({
    Color backgroundColor,
    String title,
    Function onTap,
    String socialIcon
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _buttonsPaddingHorizontal, vertical: _buttonsPaddingVertical),
      child: new Expanded(
        child: new Container(
          margin: EdgeInsets.only(right: 8.0),
          alignment: Alignment.center,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  color: backgroundColor,
                  onPressed: onTap,
                  child: new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            onPressed: onTap,
                            padding: EdgeInsets.only(
                              top: 18.0,
                              bottom: 18.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0, right:15),
                                  child: Image.asset(socialIcon, height: 23,),
                                ),

                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:_buttonsFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var notificationsClient = new HopsNotifications();

    Future<void> _loginAfterSignUp(
        String email,
        String password,
        String message,
        String customAvatar,
        { String connectionType = "Google" }
        ){
      WordpressAPI.login(
          email,
          password,
          customAvatar: customAvatar,
          connectionType: connectionType
      ).then((response){
        setState((){ this.isLoadingApiCall = false; });
        if (response){

          notificationsClient.message(context, message);
          setState(() => this.isLoadingApiCall = false );
          Navigator.pushReplacementNamed(
            context,
            "/",
          );
        }else{

          notificationsClient.message(context, "Ups! Login incorrecto. Vuelve a intentarlo o ponete en contacto con atención al cliente.");
          // here show a popup message
        }
      });
    }

    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.5,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formLoginKey,
            autovalidateMode: _autovalidate,
            child: Container(
              padding: EdgeInsets.only(top:50),
              height: MediaQuery.of(context).size.height,
              decoration: widget.headerDecoration,
              child: new Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TopLogo(topPadding: 60,),
                  SizedBox(height: 0,),
                  //_createButton(backgroundColor: Colors.black, title: "Conectate con Apple"),
                  _createButton(
                      backgroundColor: Colors.black,
                      title: "Conectate con tu Apple",
                      onTap:() => null,
                      socialIcon: "assets/images/icons/apple.png"
                  ),
                  _createButton(
                      backgroundColor: Color(0Xff3B5998),
                      title: "Conectate con Facebook",
                      onTap:() => null,
                      socialIcon: "assets/images/icons/facebook.png"
                  ),
                  _createButton(
                      backgroundColor: Color.fromRGBO(65, 120, 247, 1),
                      title: "Conectate con Google",
                      onTap:(){

                        Google googleClient = new Google();
                        googleClient.login(context).then((googleUser){


                          if (googleUser != null){
                            setState(() => this.isLoadingApiCall = true );
                            // if google ok then wordpress call
                            // try to sign up user to WooCommerce
                            Map<String, dynamic> userName = googleClient.generateNameFromDisplayName(googleUser.displayName);


                            var pwdBytes = utf8.encode(googleUser.email + SECRET_SAUCE);
                            String pwd = sha256.convert(pwdBytes).toString();

                            Customer userData = new Customer(
                              email: googleUser.email,
                              firstName: userName["firstName"],
                              lastName: userName["lastName"],
                              password: pwd,
                              avatar_url: googleUser.photoUrl
                            );


                            // create user for backend
                            WordpressAPI.signUp(userData).then((response){

                              if (response["result"] == false){
                                if (response["status"] == "ERROR_ALREADYEXISTS"){ // user already exists
                                  // then login with this details right away, same as below on true result
                                  _loginAfterSignUp(
                                      googleUser.email,
                                      pwd,
                                      "¡Que bueno es verte de vuelta! ¡Bienvenid@!",
                                      googleUser.photoUrl,
                                      connectionType: 'Google'
                                  );

                                }else{
                                  // some other error
                                  setState(() => this.isLoadingApiCall = false );
                                  //notificationsClient.message(context, "Ups! Ocurrió un error intentando ingresar con Google. Ponete en contacto.");
                                }
                              }else{
                                // then login and proceed
                                //SharedServices.setLoginDetails(loginResponse);

                                _loginAfterSignUp(
                                    googleUser.email,
                                    pwd,
                                    "¡Gracias por registrate! ¡Avanti!",
                                    googleUser.photoUrl,
                                    connectionType: 'Google'
                                );
                              }
                            });



                          }else{
                            notificationsClient.message(context, "Ups! Ocurrió un error intentando ingresar con Google. Ponete en contacto.");
                            setState(() => this.isLoadingApiCall = false );
                          }


                        });
                      },
                      socialIcon: "assets/images/icons/google.png"
                  ),
                  _createButton(
                      backgroundColor: Color.fromRGBO(25, 25, 25, 0.4),
                      title: "Conectate con tu Email",
                      onTap:() => super.gotoSignUp(widget.controller),
                      socialIcon: "assets/images/icons/email.png"
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

