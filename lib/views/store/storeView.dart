import 'package:flutter/material.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'components/body.dart';

class StoreView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      bottomNavigationBar: NavBottom(),
      body: Body(),
    );
  }
}