import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'components/account_profile_pic.dart';
import 'components/profile_menu.dart';

class AccountView extends StatelessWidget {

  final String userID;
  const AccountView ({ Key key, this.userID }): super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              BreweryProfilePic(),
              SizedBox(height: 20),
              ProfileMenu(
                text: "Mi cuenta",
                icon: Icon(Icons.verified_user),
                press: () => {},
              ),
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
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                },
              ),
              SizedBox(height: 150),
            ],
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