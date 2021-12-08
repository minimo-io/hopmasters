import 'package:Hops/models/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:Hops/constants.dart';
import 'package:Hops/services/facebook_signin.dart';
import 'package:Hops/services/google_signin.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/theme/style.dart';

import '../../helpers.dart';
import 'components/account_profile_pic.dart';
import 'components/profile_menu.dart';

import 'package:Hops/utils/notifications.dart';

class AccountView extends StatefulWidget {

  final String? userID;
  const AccountView ({ Key? key, this.userID }): super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Future<LoginResponse?>? _userData;

  @override
  void initState() {
  super.initState();
  //SharedServices.logout(context);
  _userData = SharedServices.loginDetails();
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
            future: Future.wait([
              SharedServices.loginDetails(),

            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center( child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR) );
                default:
                  if (snapshot.hasError){
                    return Text(' Ups! Errors: ${snapshot.error}');
                  }else{

                    return Column(
                      children: [
                        SizedBox(height: 40),
                        BreweryProfilePic(
                            avatarUrl: snapshot.data[0].data.avatarUrl,
                            userId: snapshot.data[0].data.id
                        ),
                        SizedBox(height: 20),

                        ProfileMenu(
                          text: "Mi perfil",
                          icon: Icon(Icons.verified_user),
                          press: (){
                            var notificationClient = new HopsNotifications();
                            notificationClient.message(context, "¡En próximas versiones!");
                          },
                        ),

                        ProfileMenu(
                          text: "Tus pedidos",
                          icon: Icon(Icons.shopping_cart),
                          press: () {
                            Navigator.pushNamed(
                              context,
                              "orders"
                            );
                          },
                        ),
                        /*
                        ProfileMenu(
                          text: "Notificaciones",
                          icon: Icon(Icons.notifications),
                          press: () {},
                        ),

                         */
                        ProfileMenu(
                          text: "Preferencias",
                          icon: Icon(Icons.settings),
                          press: () {
                            Navigator.pushNamed(
                              context,
                              "preferences",
                              arguments: { 'fromMainApp': true },
                            );
                          },
                        ),
                        ProfileMenu(
                          text: "Acerca de Hops",
                          icon: Icon(Icons.help_center),
                          press: () {

                                showAboutDialog(
                                  context: context,
                                  // applicationVersion: snapshot.data.toString(),
                                  applicationIcon: MyAppIcon(),
                                  applicationLegalese:
                                  'Esta es una aplicación pensada para mayores de 18 años.',
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text('¡Gracias por descargarte Hops! Estamos pleno desarrollo mejorando la app para apoyar a la comunidad de cervecera artesanal ¡Unite a lo local!'),
                                    ),
                                  ],
                                );


                          },
                        ),
                        ProfileMenu(
                          text: "Salir",
                          icon: Icon(Icons.logout),
                          press: () {


                            SharedServices.loginDetails().then((loginPrefs){

                              SharedServices.logout(context);
                              if (loginPrefs!.data!.connectionType == "Google"){
                                Google googleService = new Google();
                                googleService.logout().then((value) => SharedServices.logout(context));
                              }else if(loginPrefs.data!.connectionType == "Facebook"){
                                Facebook facebookService = new Facebook();

                                facebookService.logout((){
                                  print("Facebook Logout OK");
                                });
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