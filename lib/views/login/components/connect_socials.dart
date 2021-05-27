import 'dart:math';
import 'package:flutter/material.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/utils/progress_hud.dart';
import 'package:hopmasters/utils/notifications.dart';
import 'package:hopmasters/utils/validator.dart';
import 'package:hopmasters/services/wordpress_api.dart';
import 'package:hopmasters/views/login/components/social_login_buttons.dart';

import 'package:hopmasters/views/login/components/top_logo.dart';
import 'package:hopmasters/views/login/mixins/gotos.mixin.dart';

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

  var notificationsClient = new HopsNotifications();

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
                      onTap:() => null,
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

