import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/async_loader.dart';

import 'package:Hops/components/app_title.dart';

import 'package:Hops/views/preferences_signup/components/prefs_types.dart';
import 'package:Hops/views/preferences_signup/components/prefs_beer_types.dart';



class PreferencesSignUpView extends StatefulWidget {
  // login goes without slash at the moment, in order to avoid loading / assets
  static const String routeName = "preferencesSignup";

  @override
  _PreferencesSignUpViewState createState() => _PreferencesSignUpViewState();
}

class _PreferencesSignUpViewState extends State<PreferencesSignUpView> {

  Future<List<dynamic>> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = WordpressAPI.getPrefsOptions();
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
                            SizedBox(height: 30,),
                            AppTitle(title: "¿Qué estilos te preferís?"),
                            AppTitle(subtitle: "Al menos 5 opciones"),
                            SizedBox(height: 50,),
                            FutureBuilder(
                              future: _prefsFuture,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return AsyncLoader();
                                  default:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else
                                      print(snapshot.data.runtimeType );
                                      return  Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            PrefsBeerTypes(snapshot.data),
                                            SizedBox(height: 10,),
                                            AppTitle(title: "¿Qué te interesa?"),
                                            //PrefsTypes(snapshot.data),
                                            SizedBox(height: 50,),
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

