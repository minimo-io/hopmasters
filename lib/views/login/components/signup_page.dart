import 'package:flutter/material.dart';

import 'package:Hops/models/customer.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/utils/validator.dart';

import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/views/login/mixins/gotos.mixin.dart';
import 'package:Hops/components/top_logo.dart';

import 'package:Hops/views/login/components/social_login_buttons.dart';

class SignupPage extends StatefulWidget {
  PageController? controller;
  BoxDecoration? headerDecoration;

  SignupPage({this.headerDecoration, this.controller});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with GotosMixin {
  final _formSignUpKey = GlobalKey<FormState>();

  bool isLoadingApiCall = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  var notificationsClient = new HopsNotifications();

  TextEditingController signUpUsernameController = new TextEditingController();
  TextEditingController signUpPasswordController = new TextEditingController();
  TextEditingController signUpConfirmPasswordController =
      new TextEditingController();

  void _onSignUp() {
    setState(() => this.isLoadingApiCall = true);
    setState(() => this._autovalidate = AutovalidateMode.always);

    // validate signup
    if (!_formSignUpKey.currentState!.validate()) {
      setState(() {
        this.isLoadingApiCall = false;
      });
    } else {
      var password = signUpPasswordController.text.toString();
      var passwordConfirmation =
          signUpConfirmPasswordController.text.toString();

      // if all ok then create the customer model and send the request
      Customer customerModel = new Customer(
        email: signUpUsernameController.text.toString(),
        firstName: '',
        lastName: '',
        password: password,
      );

      WordpressAPI.signUp(customerModel).then((response) {
        if (response["result"] == true) {
          // send confirmation link in backend

          // login user, create session & goto login
          WordpressAPI.login(
            signUpUsernameController.text.toString(),
            password,
          ).then((response) {
            setState(() {
              this.isLoadingApiCall = false;
            });
            _formSignUpKey.currentState!.reset(); //reset form
            if (response) {
              notificationsClient.message(
                  context, WordpressAPI.MESSAGE_THANKS_FOR_SIGNUP);

              setState(() => this.isLoadingApiCall = false);
              /*
              Navigator.pushReplacementNamed(
                context,
                "/",
              );
               */
              Navigator.pushReplacementNamed(
                context,
                "preferences",
                arguments: {'fromMainApp': false},
              );
            } else {
              setState(() {
                this.isLoadingApiCall = false;
              });
              notificationsClient.message(
                  context, WordpressAPI.MESSAGE_ERROR_LOGIN);
              // here show a popup message
            }
          });
        } else {
          setState(() {
            this.isLoadingApiCall = false;
          });
          notificationsClient.message(
              context,
              WordpressAPI.MESSAGE_ERROR_USER_ALREADY_EXISTS +
                  " (" +
                  response["status"] +
                  ")");

          // here show a popup message
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.9,
      text: "Ya casi...",
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formSignUpKey,
            autovalidateMode: _autovalidate,
            child: Container(
              height: MediaQuery.of(context).size.height + 200,
              decoration: widget.headerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          onTap: () => super.gotoConnect(widget.controller!),
                          child: Icon(Icons.arrow_back))),
                  TopLogo(),
                  Row(
                    children: <Widget>[
                      Expanded(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 0.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: ACTION_BUTTON_PRIMARY_COLOR,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa un correo electrónico.';
                              }
                              if (!value.isValidEmail())
                                return "Ingresa un correo electrónico válido";

                              return null;
                            },
                            // autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: signUpUsernameController,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'pedro@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 0.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: ACTION_BUTTON_PRIMARY_COLOR,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (!value!.isValidPassword()) {
                                return "Debe tener al menos 6 caracteres con 1 número.";
                              }
                              return null;
                            },
                            controller: signUpPasswordController,
                            obscureText: true,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '*********',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
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
                  /*
                  Row(
                    children: <Widget>[
                      Checkbox(
                        controller: null,
                        //value: _agree,
                        onChanged: (bool val) => setState(() {
                          _agree = val;
                        }),
                        validator: (val) => val ? null : "You must agree before proceeding",

                      ),
                      const Text("I agree to the terms."),
                    ],
                  ),
                  */
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 0.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: ACTION_BUTTON_PRIMARY_COLOR,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (!value!.isValidPassword()) {
                                return "Debe tener al menos 6 caracteres con 1 número.";
                              }
                              var password1 =
                                  signUpPasswordController.text.toString();
                              if (password1 != value) {
                                return "Las contraseñas deben coincidir";
                              }
                              return null;
                            },
                            controller: signUpConfirmPasswordController,
                            obscureText: true,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '*********',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FlatButton(
                          child: const Text(
                            "¿Ya tienes una cuenta?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          onPressed: () => super.gotoLogin(widget.controller!),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: ACTION_BUTTON_PRIMARY_COLOR,
                            onPressed: () => _onSignUp(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Expanded(
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
                  //SocialLoginButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
