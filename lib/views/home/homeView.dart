import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/nav_bottom_v2.dart';
import 'package:hopmasters/components/search_button.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'package:hopmasters/services/wordpress.dart';

import 'package:provider/provider.dart';
import 'package:hopmasters/models/nav_menu_provider.dart';

import 'components/body.dart';


class homeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<homeView> {
  // homeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        floatingActionButton: SearchButton(),
        bottomNavigationBar: NavBottom(),
        /*bottomNavigationBar: CustomBottomNavBar(selectedMenu: HopsMenuState.home),*/
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR
            ),
          ),
          iconTheme: IconThemeData(
              color: colorScheme.secondary
          ),
          /*
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(child: Text("HOPMASTERS", style: TextStyle(color:Colors.white))),
          ),
          */
          title: Padding(
            padding: const EdgeInsets.fromLTRB(15, 28.0, 0, 8.0),
            child: Container(child: Text("HOPMASTERS", style: GoogleFonts.russoOne(
                textStyle: TextStyle(color: colorScheme.secondary)
            ))),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Carrito',
                onPressed: () {

                  Navigator.pushNamed(context, '/cart');

                  //topBeers();
                },
              ),
            ),
            Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 18.0, 6.0, 0),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      tooltip: 'Notificaciones',
                      onPressed: () {
                        print("OHH BOY MENU");
                      },
                    ),
                  ),
                  Positioned(
                    right:15,
                    top:20,
                    child: Container(
                        height: 18,
                        width:18,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.5, color: Colors.white)
                        ),
                        child: Center(child: Text("4", style: TextStyle(fontSize: 11, height: 1, color: Colors.white, fontWeight: FontWeight.w600)))
                    ),
                  )
                ]
            )
          ],
        ),
        body: Body()
    );
  }
}

// class homeView extends StatelessWidget{

// }
