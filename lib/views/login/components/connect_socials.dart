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

  static const _buttonsPadding = 16.0;
  static const _buttonsFontSize = 16.0;

  Widget _createButton({ Color backgroundColor, String title, Function onTap}){
    return Padding(
      padding: const EdgeInsets.all(_buttonsPadding),
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
                              top: 20.0,
                              bottom: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Icon(
                                  Icons.face_outlined,
                                  color: Colors.white,
                                  size: 15.0,
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
                  TopLogo(),
                  SizedBox(height: 80,),
                  //_createButton(backgroundColor: Colors.black, title: "Conectate con Apple"),
                  _createButton(
                      backgroundColor: Color(0Xff3B5998),
                      title: "Conectate con Facebook",
                      onTap:() => null
                  ),
                  _createButton(
                      backgroundColor: Color.fromRGBO(65, 120, 247, 1),
                      title: "Conectate con Google",
                      onTap:() => null
                  ),
                  _createButton(
                      backgroundColor: Color.fromRGBO(25, 25, 25, 0.4),
                      title: "Conectate con tu Email",
                      onTap:() => super.gotoSignUp(widget.controller)
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

