import 'package:flutter/material.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/search_button.dart';
import 'components/body.dart';

class StoreView extends StatelessWidget {
  static const String routeName = "/store";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      floatingActionButton: SearchButton(),
      bottomNavigationBar: NavBottom(),
      body: Body(),
    );
  }
}