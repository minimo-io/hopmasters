import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/views/home/components/bannerBreweries.dart';

import 'package:provider/provider.dart';
import 'package:hopmasters/models/nav_menu_provider.dart';

import 'components/favs_tabs.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key key}) : super(key: key);

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