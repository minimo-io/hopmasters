import 'package:flutter/material.dart';

import 'package:hopmasters/models/customer.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/utils/progress_hud.dart';
import 'package:hopmasters/utils/notifications.dart';
import 'package:hopmasters/utils/validator.dart';

import 'package:hopmasters/services/wordpress_api.dart';

import 'package:hopmasters/views/login/mixins/gotos.mixin.dart';
import 'package:hopmasters/views/login/components/top_logo.dart';

class SignupPage extends StatefulWidget {
  PageController controller;
  BoxDecoration headerDecoration;

  SignupPage({
    this.headerDecoration,
    this.controller
  });

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with GotosMixin{
  final _formSignUpKey = GlobalKey<FormState>();

  bool isLoadingApiCall = false;
  var notificationsClient = new HopsNotifications();

  TextEditingController signUpUsernameController = new TextEditingController();
  TextEditingController signUpPasswordController = new TextEditingController();
  TextEditingController signUpConfirmPasswordController = new TextEditingController();

  void _onSignUp(){

    setState((){ this.isLoadingApiCall = true; });

    // validate signup
    if (! _formSignUpKey.currentState.validate()) {
      setState((){ this.isLoadingApiCall = false; });
    }else{

      var password = signUpPasswordController.text.toString();
      var passwordConfirmation = signUpConfirmPasswordController.text.toString();

      if (passwordConfirmation != password) {

        notificationsClient.message(context, "Las contraseñas no coinciden. Por favor verifícalas.");
        setState((){
          this.isLoadingApiCall = false;
        });

      }else {
        // if all ok then create the customer model and send the request
        Customer customerModel = new Customer(
          email: signUpUsernameController.text.toString(),
          firstName: '',
          lastName: '',
          password: password,

        );

        WordpressAPI.signUp(customerModel).then((response) {
          setState(() {
            this.isLoadingApiCall = false;
          });
          if (response) {

            notificationsClient.message(context, "Registrado correctamente");
          } else {
            notificationsClient.message(context, "Ups! Ya existe un registro.");

            // here show a popup message
          }
        });
      }

    }




  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.5,
      child: Form(
        key: _formSignUpKey,
        child: Container(
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
                            return 'Por favor ingresa un correo electrónico.';
                          }
                          if (! value.isValidEmail()) return "Ingresa un correo electrónico válido";

                          return null;
                        },
                        controller: signUpUsernameController,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña.';
                          }
                          if (value.length < 5) return "La contraseña debe tener al menos 5 caracteres.";

                          return null;
                        },
                        controller: signUpPasswordController,
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
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONFIRMA LA CONTRASEÑA",
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
                            return 'Por favor ingresa una contraseña.';
                          }
                          if (value.length < 5) return "La contraseña debe tener al menos 5 caracteres.";

                          return null;
                        },
                        controller: signUpConfirmPasswordController,
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
                        "¿Ya tienes una cuenta?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => super.gotoLogin(widget.controller),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: ACTION_BUTTON_PRIMARY_COLOR,
                        onPressed: () => _onSignUp(),
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
                                  "REGISTRARSE",
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
            ],
          ),
        ),
      ),
    );
  }
}

