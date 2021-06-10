import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Hops/models/category.dart';

import 'package:Hops/theme/style.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/top_logo.dart';
import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/preferences_signup/components/prefs_types.dart';
import 'package:Hops/views/preferences_signup/components/prefs_beer_types.dart';




class PreferencesSignUpView extends StatefulWidget {
  // login goes without slash at the moment, in order to avoid loading / assets
  static const String routeName = "preferences";

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
              else {
                return WillPopScope(
                  onWillPop: () {
                    return new Future(() => false);
                  },
                  child: new Scaffold(
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
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }else{



                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            PrefsBeerTypes(snapshot.data),
                                            SizedBox(height: 40,),
                                            PrefsTypes(snapshot.data),
                                            SizedBox(height: 20),
                                            Consumer<Preferences>(
                                              builder: (context, preferences, child){
                                                int prefsCount = preferences.items.length;
                                                String continueText = "Elige 5 preferencias (vas " + prefsCount.toString() + ")";


                                                void fnContinue(){
                                                  Navigator.pushNamed(
                                                    context,
                                                    "/",
                                                  );
                                                };

                                                MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
                                                if (prefsCount >= 5){
                                                  backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));
                                                  continueText = "Continuar";

                                                }

                                                return Container(
                                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(

                                                      onPressed: (prefsCount >= 5 ? fnContinue :  null),
                                                      child: Text(
                                                            continueText,
                                                            style: TextStyle(
                                                              fontSize: 20
                                                            )
                                                      ),
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
                                                          foregroundColor: MaterialStateProperty
                                                              .all<Color>(
                                                              Colors.black.withOpacity(
                                                                  .6)),
                                                          backgroundColor: backgroundColor,
                                                          shape: MaterialStateProperty
                                                              .all<
                                                              RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius
                                                                      .circular(18.0),
                                                                  side: BorderSide(
                                                                      color: Colors.black
                                                                          .withOpacity(
                                                                          .2))
                                                              )
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                            SizedBox(height: 350,),
                                          ],
                                        );
                                      }
                                  }


                                }

                              ),
                              SizedBox(height: 50,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          }


        }
    );
  }
}

