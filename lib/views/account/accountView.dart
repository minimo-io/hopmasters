import 'package:Hops/models/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:Hops/constants.dart';
import 'package:Hops/services/google_signin.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/theme/style.dart';

import 'components/account_profile_pic.dart';
import 'components/profile_menu.dart';

class AccountView extends StatefulWidget {

  final String userID;
  const AccountView ({ Key key, this.userID }): super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Future<LoginResponse> _userData;

  @override
  void initState() {
  super.initState();
  _userData = SharedServices.loginDetails();
  //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: FutureBuilder(
            future: _userData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center( child: CircularProgressIndicator() );
                default:
                  if (snapshot.hasError){
                    return Text('Ups! Error: ${snapshot.error}');
                  }else{
                    return Column(
                      children: [
                        SizedBox(height: 40),
                        BreweryProfilePic(avatarUrl: snapshot.data.data.avatarUrl),
                        SizedBox(height: 20),
                        ProfileMenu(
                          text: "Mi cuenta",
                          icon: Icon(Icons.verified_user),
                          press: () => {},
                        ),
                                            /*
                        ProfileMenu(
                          text: "Login Screen",
                          icon: Icon(Icons.login),
                          press: () {
                            Navigator.pushNamed(
                              context,
                              "/login"
                            );
                          },
                        ),

                         */
                        ProfileMenu(
                          text: "Notificaciones",
                          icon: Icon(Icons.notifications),
                          press: () {},
                        ),
                        ProfileMenu(
                          text: "Configuración",
                          icon: Icon(Icons.settings),
                          press: () {},
                        ),
                        ProfileMenu(
                          text: "Acerca de Hops",
                          icon: Icon(Icons.help_center),
                          press: () {

                            showAboutDialog(
                              context: context,
                              applicationVersion: '2.0.1',
                              applicationIcon: MyAppIcon(),
                              applicationLegalese:
                              'This application has been approved for all audiences.',
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text('This is where I\'d put more information about '
                                      'this app, if there was anything interesting to say.'),
                                ),
                              ],
                            );

                          },
                        ),
                        ProfileMenu(
                          text: "Salir",
                          icon: Icon(Icons.logout),
                          press: () {
                            //String authService = "Google";
                            SharedServices.loginDetails().then((prefs){
                              print(prefs.data.connectionType);
                              SharedServices.logout(context);

                              if (prefs.data.connectionType == "Google"){
                                Google googleService = new Google();
                                googleService.logout().then((value) => SharedServices.logout(context));
                              }

                            });


                          },
                        ),
                        SizedBox(height: 150),
                      ],
                    );
                  }
              }
            }
          ),
        ),
      ),
    );
  }
}

class MyAppIcon extends StatelessWidget {
  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: size,
          height: size,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}