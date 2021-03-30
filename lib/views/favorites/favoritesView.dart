
import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/search_button.dart';

import 'components/body.dart';

class FavoritesView extends StatelessWidget{
  static const String routeName = "/favs";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopAppBar(),
      floatingActionButton: SearchButton(),
      body: Body(),
      bottomNavigationBar: NavBottom(),
    );
  }

}