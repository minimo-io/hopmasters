import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'account_profile_pic.dart';
import 'profile_menu.dart';

class Body extends StatelessWidget {
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
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}