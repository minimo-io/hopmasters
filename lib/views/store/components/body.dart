import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:provider/provider.dart';
import 'package:hopmasters/models/nav_menu_provider.dart';


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
              SizedBox(height: (30)),
              Row(
                children: [
                  Consumer<NavMenuProvider>(
                      builder: (context, menu, child){
                        return Container(child: Center(child: Text("Current index: " + menu.currentIndex.toString())));
                      }
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height),
            ],
          ),
        ),
      ),
    );
  }
}