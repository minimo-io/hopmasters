import 'package:flutter/material.dart';

import 'package:Hops/helpers.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/utils/validator.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/top_logo.dart';
import 'package:Hops/views/login/mixins/gotos.mixin.dart';

class LoginPage extends StatefulWidget {
  BoxDecoration? headerDecoration;
  PageController? controller;
  LoginPage({this.headerDecoration, this.controller});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with GotosMixin {
  final _formLoginKey = GlobalKey<FormState>();

  bool isLoadingApiCall = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  var notificationsClient = HopsNotifications();

  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  // final FocusNode _loginUsernameFocusNode = FocusNode();
  // final FocusNode _loginPasswordFocusNode = FocusNode();

  void _onLogin(BuildContext context) {
    setState(() => this.isLoadingApiCall = true);
    setState(() => this._autovalidate = AutovalidateMode.always);
    // validate login
    if (!_formLoginKey.currentState!.validate()) {
      setState(() {
        this.isLoadingApiCall = false;
      });
      // notificationsClient.message(context, "Ups! Por favor completa correctamente todos los campos del formulario.");
    } else {
      _formLoginKey.currentState!.save();
      WordpressAPI.login(
              loginUsernameController.text, loginPasswordController.text)
          .then((response) {
        setState(() {
          isLoadingApiCall = false;
        });
        if (response) {
          _formLoginKey.currentState!.reset();
          // here save token and continue

          notificationsClient.message(context, "Bienvenid@!");
          Navigator.pushReplacementNamed(
            context,
            "/",
          );
        } else {
          notificationsClient.message(context,
              "Ups! Login incorrecto. Vuelve a intentarlo o ponete en contacto con atención al cliente.");
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
      text: "Entrando...",
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formLoginKey,
            autovalidateMode: _autovalidate,
            child: Container(
              height: MediaQuery.of(context).size.height + 100,
              decoration: widget.headerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: GestureDetector(
                          onTap: () => super.gotoSignUp(widget.controller!),
                          child: const Icon(Icons.arrow_back))),
                  TopLogo(),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
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
                                //_loginUsernameFocusNode.requestFocus();
                                return 'Por favor ingresa un correo electrónico.';
                              }
                              if (!value.isValidEmail()) {
                                //_loginUsernameFocusNode.requestFocus();
                                return "Ingresa un correo electrónico válido";
                              }
                              return null;
                            },
                            // autofocus: true,
                            //focusNode: _loginUsernameFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            controller: loginUsernameController,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'pepe@gmail.com',
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
                                //_loginPasswordFocusNode.requestFocus();
                                return "Debe tener al menos 6 caracteres con 1 número.";
                              }
                              return null;
                            },
                            controller: loginPasswordController,
                            //focusNode: _loginPasswordFocusNode,
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
                        child: TextButton(
                          child: Text(
                            "¿Olvidaste la contraseña?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          onPressed: () => Helpers.launchURL(
                              "https://hops.uy/mi-cuenta/lost-password/"),
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
                          child: TextButton(
                            onPressed: () => _onLogin(context),
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
                  // SocialLoginButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
