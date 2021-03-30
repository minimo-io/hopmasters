import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/search_button.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/services/wordpress.dart';

import 'components/body.dart';


class homeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<homeView> {
  // homeView({Key key}) : super(key: key);

  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {

    // final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        floatingActionButton: SearchButton(),
        bottomNavigationBar: NavBottom(),
        appBar: TopAppBar(),
        body: Body()
    );
  }
}

// class homeView extends StatelessWidget{

// }
