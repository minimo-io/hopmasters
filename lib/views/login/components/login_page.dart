import 'package:flutter/material.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/utils/progress_hud.dart';
import 'package:hopmasters/utils/notifications.dart';
import 'package:hopmasters/utils/validator.dart';
import 'package:hopmasters/services/wordpress_api.dart';

import 'package:hopmasters/views/login/components/top_logo.dart';

class LoginPage extends StatefulWidget {
  BoxDecoration headerDecoration;
  PageController controller;
  LoginPage({
    this.headerDecoration,
    this.controller
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormState>();
  bool isLoadingApiCall = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  var notificationsClient = new HopsNotifications();

  TextEditingController loginUsernameController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  // final FocusNode _loginUsernameFocusNode = FocusNode();
  // final FocusNode _loginPasswordFocusNode = FocusNode();


  void _onLogin(BuildContext context){

    setState(() => this.isLoadingApiCall = true );
    setState(() => this._autovalidate = AutovalidateMode.always );
    // validate login
    if (! _formLoginKey.currentState.validate()) {
      setState((){ this.isLoadingApiCall = false; });
      // notificationsClient.message(context, "Ups! Por favor completa correctamente todos los campos del formulario.");
    }else{
      _formLoginKey.currentState.save();
      WordpressAPI.login(loginUsernameController.text, loginPasswordController.text).then((response) {
        setState((){
          this.isLoadingApiCall = false;
        });
        if (response){
          // here save token and continue

          notificationsClient.message(context, "Bienvenid@!");
          Navigator.pushNamed(
            context,
            "/",
          );
        }else{

          notificationsClient.message(context, "Ups! Login incorrecto. Vuelve a intentarlo o ponete en contacto con atención al cliente.");
          // here show a popup message
        }
      });

    }
  }


  @override
  Widget build(BuildContext context) {


    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.5,
      child: Form(
        key: _formLoginKey,
        autovalidateMode: _autovalidate,
        child: new Container(
          height: MediaQuery.of(context).size.height,
          decoration: widget.headerDecoration,
          child: new Column(
            children: <Widget>[
              TopLogo(),
              SizedBox(height: 150,),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: ACTION_BUTTON_PRIMARY_COLOR,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            //_loginUsernameFocusNode.requestFocus();
                            return 'Por favor ingresa un correo electrónico.';
                          }
                          if (! value.isValidEmail()){
                            //_loginUsernameFocusNode.requestFocus();
                            return "Ingresa un correo electrónico válido";
                          }
                          return null;
                        },
                        // autofocus: true,
                        //focusNode: _loginUsernameFocusNode,
                        controller: loginUsernameController,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'mail@minimo.io',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONTRASEÑA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: ACTION_BUTTON_PRIMARY_COLOR,
                        width: 1,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if ( ! value.isValidPassword() ){
                            //_loginPasswordFocusNode.requestFocus();
                            return "Debe tener al menos 6 caracteres con 1 número.";
                          }
                          return null;
                        },
                        controller: loginPasswordController,
                        //focusNode: _loginPasswordFocusNode,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
                        "¿Olvidaste la contraseña?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: ACTION_BUTTON_PRIMARY_COLOR,
                        onPressed: () => _onLogin(context),
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "INGRESAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                    Text(
                      "O CONECTATE CON",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
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
                                color: Color(0Xff3B5998),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: ()=>{},
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              /*
                                              Icon(
                                                Icons.face_outlined,
                                                color: Colors.white,
                                                size: 15.0,
                                              ),
                                               */
                                              Text(
                                                "FACEBOOK",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
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
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.only(left: 8.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xffdb3236),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: ()=>{},
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              /*
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 15.0,
                                              ),

                                               */
                                              Text(
                                                "GOOGLE",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

