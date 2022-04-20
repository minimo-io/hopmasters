
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Hops/models/login.dart';
import 'package:Hops/models/preferences.dart';

import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';

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
  bool fromMainApp;

  PreferencesSignUpView({ this.fromMainApp = false });

  @override
  _PreferencesSignUpViewState createState() => _PreferencesSignUpViewState();
}

class _PreferencesSignUpViewState extends State<PreferencesSignUpView> {

  Future<List<dynamic>?>? _prefsFuture;
  Future<LoginResponse?>? _userData;
  bool isLoadingApiCall = false;
  double? bottomHeight;


  @override
  void initState() {
    super.initState();
    _prefsFuture = WordpressAPI.getPrefsOptions();
    _userData = SharedServices.loginDetails();
    bottomHeight = 70;


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
                    if (widget.fromMainApp) return new Future(() => true);
                    return new Future(() => false);
                  },
                  child: new Scaffold(
                    bottomNavigationBar: AnimatedContainer(
                      duration: new Duration(milliseconds: 500),
                      height: this.bottomHeight,
                      padding: EdgeInsets.only( bottom: 5 ),
                      decoration: BoxDecoration(
                        gradient: PRIMARY_GRADIENT_COLOR,
                      ),
                      child: Consumer<Preferences>(
                          builder: (context, preferences, child){
                            int prefsCount = preferences.items.length + preferences.itemsNews.length;
                            String continueText = "Elige 5 preferencias (vas " + prefsCount.toString() + ")";


                            void fnContinue()async{
                              HopsNotifications notificationClient =  new HopsNotifications();
                              setState(() => this.isLoadingApiCall = true );
                              setState(() => this.bottomHeight = 1 );
                              try {
                                // get user details
                                LoginResponse? userLogin = await SharedServices.loginDetails();
                                int? userId = userLogin?.data?.id;

                                bool res = await WordpressAPI.setPrefsOptions( (userId != null ? userId : 0) , preferences.items, preferences.itemsNews);
                                if (res == true){
                                  setState(() => this.isLoadingApiCall = false );
                                  setState(() => this.bottomHeight = 70 );
                                  // save Shared Service for each preference

                                  await SharedServices.savePreferences("beer_types", preferences.items);
                                  await SharedServices.savePreferences("news_types", preferences.itemsNews);

                                  notificationClient.message(context, WordpressAPI.MESSAGE_OK_UPDATING_PREFS);
                                  if (widget.fromMainApp){
                                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                  }else{
                                    Navigator.pushNamed(
                                      context,
                                      "/",
                                    );
                                  }

                                }
                              } on Exception catch (exception) {
                                setState(() => this.isLoadingApiCall = false );
                                setState(() => this.bottomHeight = 70 );
                                notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_UPDATING_PREFS);
                                print(exception);
                              } catch (error) {
                                setState(() => this.isLoadingApiCall = false );
                                setState(() => this.bottomHeight = 70 );
                                notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_UPDATING_PREFS);
                                print(error);
                              }



                            };

                            MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
                            if (prefsCount >= 5){
                              backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));
                              continueText = "Continuar";
                              if(widget.fromMainApp) continueText = "Guardar";
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
                    ),
                    body: SafeArea(
                      child: ProgressHUD(
                        inAsyncCall: isLoadingApiCall,
                        opacity: 0.9,
                        text:"Guardando preferencias...",
                        child: SingleChildScrollView(
                          child: new Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: linearGradient,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (widget.fromMainApp) Container(
                                  height:null,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 8, left:8),
                                        child: GestureDetector(
                                            onTap:(){
                                              if (widget.fromMainApp){
                                                Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                              }else{
                                                Navigator.pushNamed(
                                                  context,
                                                  "/",
                                                );
                                              }


                                            },
                                            child: Icon(Icons.arrow_back)
                                        )
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                  future: _userData,
                                  builder: (BuildContext context, AsyncSnapshot userData) {
                                    String? finalName = "¡Hola";
                                    if (userData.data != null
                                        && userData.data.data != null
                                        && userData.data.data.displayName != null){
                                      Map<String, dynamic> mapFinalName = WordpressAPI.generateNameFromDisplayName(userData.data.data.displayName);
                                      // check if has an arroba then no real name
                                      if (! mapFinalName["firstName"].contains("@")) finalName += " " + mapFinalName["firstName"];
                                    }

                                    finalName += "!";

                                    return TopLogo(
                                    topPadding: (widget.fromMainApp ? 20 : 50),
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
                                              PrefsTypes(snapshot.data),

                                              SizedBox(height: 40,),
                                              PrefsBeerTypes(snapshot.data),
                                              SizedBox(height: 20),
                                              SizedBox(height: 100,),
                                            ],
                                          );
                                        }
                                    }


                                  }

                                ),
                              ],
                            ),
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

