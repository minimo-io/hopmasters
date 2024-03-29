import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/utils/size_config.dart';
import 'package:Hops/helpers.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/services/facebook_signin.dart';
import 'package:Hops/services/google_signin.dart';

import 'package:Hops/components/top_logo.dart';
import 'package:Hops/views/login/mixins/gotos.mixin.dart';

import 'package:Hops/models/customer.dart';

import 'package:location/location.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ConnectSocialsPage extends StatefulWidget {
  BoxDecoration? headerDecoration;
  PageController? controller;

  ConnectSocialsPage({this.headerDecoration, this.controller});

  @override
  _ConnectSocialsPageState createState() => _ConnectSocialsPageState();
}

class _ConnectSocialsPageState extends State<ConnectSocialsPage>
    with GotosMixin {
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
  //static const _buttonsFontSize = 18.0;
  static const _buttonsFontSize = 5.0;

  Widget _createButton(
      {Color? backgroundColor,
      required String title,
      Function? onTap,
      required String socialIcon}) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _buttonsPaddingHorizontal,
          vertical: _buttonsPaddingVertical),
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: onTap as void Function()?,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          onPressed: onTap,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, right: 15),
                                child: Image.asset(
                                  socialIcon,
                                  height: 23,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal *
                                          _buttonsFontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var notificationsClient = new HopsNotifications();

    Future<void> _loginAfterSignUp(
        String? email, String? password, String message, String? customAvatar,
        {String connectionType = "Google", bool? signUpResult}) async {
      WordpressAPI.login(email, password,
              customAvatar: customAvatar, connectionType: connectionType)
          .then((response) {
        setState(() {
          this.isLoadingApiCall = false;
        });
        if (response) {
          notificationsClient.message(context, message);
          setState(() => this.isLoadingApiCall = false);
          String goToRoute = "/";

          // ask for location
          Location location = Location();

          location.serviceEnabled().then((serviceEnabled) {
            if (!serviceEnabled) {
              location.requestService().then((serviceEnabled) {
                if (!serviceEnabled) {
                  return;
                } else {
                  location.hasPermission().then((permissionGranted) {
                    if (permissionGranted == PermissionStatus.denied) {
                      location.requestPermission().then((permissionGranted) {
                        if (permissionGranted != PermissionStatus.granted) {
                          return;
                        } else {
                          location
                              .getLocation()
                              .then((LocationData locationData) {
                            print(locationData);
                          });
                        }
                      });
                    }
                  });
                }
              });
            } else {
              location.hasPermission().then((permissionGranted) {
                print("Permission granted?");
                print(permissionGranted);
                if (permissionGranted == PermissionStatus.denied) {
                  location.requestPermission().then((permissionGranted) {
                    if (permissionGranted != PermissionStatus.granted) {
                      return;
                    } else {
                      location.getLocation().then((LocationData locationData) {
                        print(locationData);
                      });
                    }
                  });
                }
              });
            }
          });

          // redirect
          if (signUpResult == true) {
            // Navigator.pushReplacementNamed(
            //   context,
            //   "preferences",
            //   arguments: {'fromMainApp': false},
            // );
            Navigator.pushReplacementNamed(
              context,
              "/",
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              "/",
            );
          }
        } else {
          notificationsClient.message(
              context, WordpressAPI.MESSAGE_ERROR_LOGIN);
          // here show a popup message
        }
      });
    }

    Future<Map<String, dynamic>>? _trySignUpAndLogin(
        Customer customer, String connectionType) {
      WordpressAPI.signUp(customer).then((response) {
        if (response["result"] == false) {
          if (response["status"] == "ERROR_ALREADYEXISTS") {
            // user already exists
            // then login with this details right away, same as below on true result
            _loginAfterSignUp(customer.email, customer.password,
                WordpressAPI.MESSAGE_OK_LOGIN_BACK, customer.avatar_url,
                signUpResult: response["result"],
                connectionType: connectionType // Google, Facebook, Apple, Email
                );
          } else {
            // some other error
            setState(() => this.isLoadingApiCall = false);
            //notificationsClient.message(context, "Ups! Ocurrió un error intentando ingresar con Google. Ponete en contacto.");
          }
        } else {
          // then login and proceed
          //SharedServices.setLoginDetails(loginResponse);

          _loginAfterSignUp(customer.email, customer.password,
              WordpressAPI.MESSAGE_THANKS_FOR_SIGNUP, customer.avatar_url,
              signUpResult: response["result"],
              connectionType: connectionType // Google, Facebook, Apple, Email
              );
        }
      });
    }

    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.9,
      text: "¡Gluc gluc! Entrando...",
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formLoginKey,
            autovalidateMode: _autovalidate,
            child: Container(
              //padding: EdgeInsets.only(top:50),
              height: MediaQuery.of(context).size.height + 80,
              decoration: widget.headerDecoration,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TopLogo(
                    topPadding: 0,
                    bottomPadding: 50.0,
                  ),
                  //_createButton(backgroundColor: Colors.black, title: "Conectate con Apple"),
                  /*
                  _createButton(
                      backgroundColor: Colors.black,
                      title: "Conectate con Apple ID",
                      onTap:() => null,
                      socialIcon: "assets/images/icons/apple.png"
                  ),
                    */
                  if (SHOW_LOGIN_APPLE)
                    _createButton(
                      backgroundColor: Colors.black,
                      title: "Conectate con Apple",
                      socialIcon: "assets/images/icons/apple.png",
                      onTap: () async {
                        /*
                        setState(() => this.isLoadingApiCall = true );
                        Facebook facebookClient = new Facebook();
                        Map<String, dynamic>? userData = await facebookClient.login();

                        if (userData != null){

                          Map<String, dynamic> userName = WordpressAPI.generateNameFromDisplayName(userData["name"]);
                          String pwd = WordpressAPI.generatePassword(userData["email"]);


                          Customer customer = new Customer(
                              email: userData["email"],
                              firstName: userName["firstName"],
                              lastName: userName["lastName"],
                              password: pwd,
                              avatar_url: userData["picture"]["data"]["url"]
                          );

                          // try to create user if does not exists & login
                          _trySignUpAndLogin(customer, 'Facebook');

                          //setState(() => this.isLoadingApiCall = false );
                        }else{
                          notificationsClient.message(context, WordpressAPI.MESSAGE_ERROR_LOGIN_UNEXPECTED);
                          setState(() => this.isLoadingApiCall = false );
                        }
*/
                        if (DEBUG) print("Lets do it! OK!");
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );

                        print(credential);
                      },
                    ),

                  if (SHOW_LOGIN_FACEBOOK)
                    _createButton(
                      backgroundColor: Color(0Xff3B5998),
                      title: "Conectate con Facebook",
                      socialIcon: "assets/images/icons/facebook.png",
                      onTap: () async {
                        setState(() => this.isLoadingApiCall = true);
                        Facebook facebookClient = new Facebook();

                        Map<String, dynamic>? userData =
                            await facebookClient.login();

                        if (userData != null) {
                          Map<String, dynamic> userName =
                              WordpressAPI.generateNameFromDisplayName(
                                  userData["name"]);
                          String pwd =
                              WordpressAPI.generatePassword(userData["email"]);

                          Customer customer = Customer(
                              email: userData["email"],
                              firstName: userName["firstName"],
                              lastName: userName["lastName"],
                              password: pwd,
                              avatar_url: userData["picture"]["data"]["url"]);

                          // try to create user if does not exists & login
                          _trySignUpAndLogin(customer, 'Facebook');

                          //setState(() => this.isLoadingApiCall = false );
                        } else {
                          notificationsClient.message(context,
                              WordpressAPI.MESSAGE_ERROR_LOGIN_UNEXPECTED);
                          setState(() => this.isLoadingApiCall = false);
                        }
                      },
                    ),
                  // // google
                  // if (SHOW_LOGIN_GOOGLE) _createButton(
                  //     backgroundColor: Color.fromRGBO(65, 120, 247, 1),
                  //     title: "Conectate con Google",
                  //     onTap: () {
                  //       Google googleClient = new Google();
                  //       print(googleClient);
                  //       googleClient.login(context).then((googleUser) {
                  //         print(googleUser);

                  //         if (googleUser != null) {
                  //           setState(() => this.isLoadingApiCall = true);
                  //           // if google ok then wordpress call
                  //           // try to sign up user to WooCommerce
                  //           Map<String, dynamic> userName =
                  //               WordpressAPI.generateNameFromDisplayName(
                  //                   (googleUser.displayName != null
                  //                       ? googleUser.displayName!
                  //                       : googleUser.email));

                  //           String pwd =
                  //               WordpressAPI.generatePassword(googleUser.email);

                  //           Customer customer = new Customer(
                  //               email: googleUser.email,
                  //               firstName: userName["firstName"],
                  //               lastName: userName["lastName"],
                  //               password: pwd,
                  //               avatar_url: googleUser.photoUrl);

                  //           // try to create user if does not exists & login
                  //           _trySignUpAndLogin(customer, 'Google');
                  //         } else {
                  //           notificationsClient.message(context,
                  //               WordpressAPI.MESSAGE_ERROR_LOGIN_UNEXPECTED);
                  //           setState(() => this.isLoadingApiCall = false);
                  //         }
                  //       });
                  //     },
                  //     socialIcon: "assets/images/icons/google.png"),
                  if (SHOW_LOGIN_EMAIL)
                    _createButton(
                        backgroundColor: const Color.fromRGBO(59, 59, 59, 1),
                        title: "Conectate con tu Email",
                        onTap: () => super.gotoSignUp(widget.controller!),
                        socialIcon: "assets/images/icons/email.png"),
                  const SizedBox(
                    height: 20,
                  ),

                  // version number
                  FutureBuilder(
                      future: Helpers.buildVersionNumber(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text("No available version",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black.withOpacity(0.8)));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3.0),
                              child: Text(snapshot.data.toString(),
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black.withOpacity(.8))),
                            );
                          }
                        } else {
                          return Container();
                        }
                      }),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
