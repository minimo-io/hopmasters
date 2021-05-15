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
                text: "Ayuda",
                icon: Icon(Icons.help_center),
                press: () {},
              ),
              ProfileMenu(
                text: "Salir",
                icon: Icon(Icons.logout),
                press: () {},
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}