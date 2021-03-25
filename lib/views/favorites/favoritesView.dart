
import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/components/nav_bottom.dart';


import 'components/body.dart';

class FavoritesView extends StatefulWidget{
  @override
  _favoritesViewState createState() => _favoritesViewState();

}

class _favoritesViewState extends State<FavoritesView>{

  @override

  Widget build(BuildContext context){
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("Favoritas"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR
          ),
        ),
      ),
      */
      appBar: TopAppBar(),
      body: Body(),
      bottomNavigationBar: NavBottom(),
    );
  }

}