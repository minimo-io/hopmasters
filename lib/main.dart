import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/routes.dart';
import 'package:provider/provider.dart';
import 'package:hopmasters/models/nav_menu_provider.dart';
import 'package:hopmasters/views/notFound/not_found_page.dart';

const String _appTitle = "Hopmasters";

void main() => runApp(HopmastersApp());

class HopmastersApp extends StatelessWidget{
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  // The override is not required but nice to specify
  // All classes have a build() so we override it
  Widget build(BuildContext context){
    // this is from the material package.
    // more docs here: https://api.flutter.dev/flutter/material/MaterialApp-class.html
    return ChangeNotifierProvider(
      create: (context) => NavMenuProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _appTitle,
        theme: hopmastersTheme(),
        initialRoute: '/',
        routes: routes,
        onUnknownRoute: (RouteSettings setting) {
          // To can ask the RouterSettings for unknown router name.
          String unknownRoute = setting.name ;
          return new MaterialPageRoute(
              builder: (context) => NotFoundPage()
          );
        },
      ),
    );
  }
}