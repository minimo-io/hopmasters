import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/top_logo.dart';
import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/preferences_signup/components/prefs_types.dart';
import 'package:Hops/views/preferences_signup/components/prefs_beer_types.dart';




class PreferencesSignUpView extends StatefulWidget {
  // login goes without slash at the moment, in order to avoid loading / assets
  static const String routeName = "preferencesSignup";

  @override
  _PreferencesSignUpViewState createState() => _PreferencesSignUpViewState();
}

class _PreferencesSignUpViewState extends State<PreferencesSignUpView> {

  Future<List<dynamic>?>? _prefsFuture;
  Future<LoginResponse?>? _userData;

  @override
  void initState() {
    super.initState();
    _prefsFuture = WordpressAPI.getPrefsOptions();
    _userData = SharedServices.loginDetails();
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
        future: _prefsFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return AsyncLoader();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return new Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: linearGradient,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder(
                              future: _userData,
                              builder: (BuildContext context, AsyncSnapshot userData) {
                                String? finalName = "¡Hola";
                                if (userData.data.data.displayName != null){
                                  Map<String, dynamic> mapFinalName = WordpressAPI.generateNameFromDisplayName(userData.data.data.displayName);
                                  finalName += " " + mapFinalName["firstName"];
                                }

                                finalName += "!";

                                return TopLogo(
                                topPadding: 50,
                                bottomPadding: 0,
                                showSlogan: false,
                                title: finalName,
                                );
                            }),
                            SizedBox(height: 30,),
                            FutureBuilder(
                              future: _prefsFuture,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return AsyncLoader();
                                  default:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else

                                      return  Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            PrefsBeerTypes(snapshot.data),
                                            SizedBox(height: 40,),
                                            PrefsTypes(snapshot.data),
                                            SizedBox(height: 350,),
                                          ],
                                        );

                                }


                              }

                            ),
                            SizedBox(height: 50,),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
          }


        }
    );
  }
}

