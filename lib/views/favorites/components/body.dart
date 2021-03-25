import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/views/home/components/bannerBreweries.dart';

import 'favs_tabs.dart';

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
              FavsTabs(),
            ],
          ),
        ),
      ),
    );
  }
}