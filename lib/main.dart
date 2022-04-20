import 'package:Hops/models/loader.dart';
import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/routes.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/login.dart';

// providers
import 'package:Hops/models/nav_menu_provider.dart';
import 'package:Hops/models/preferences.dart';
import 'package:Hops/models/cart.dart';


String _initialRoute = "login";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedServices.isLoggedIn();
  /*
  var _beerTypes = await SharedServices.getPreferences("beer_types");
  var _newsTypes = await SharedServices.getPreferences("news_types");
  int countPrefs = _beerTypes!.length + _newsTypes!.length;
   */


  if (_result){
    // set initial route
    _initialRoute = "/";
  }

  runApp(HopsApp());
}

class HopsApp extends StatelessWidget{
  @override
  // The override is not required but nice to specify
  // All classes have a build() so we override it
  Widget build(BuildContext context){

    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (context) => NavMenuProvider(), ),
        ChangeNotifierProvider( create: (context) => Preferences(), ),
        ChangeNotifierProvider( create: (context) => Cart(), ),
        // ChangeNotifierProvider( create: (context) => Loader(), ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: APP_TITLE,
        theme: hopmastersTheme(),
        initialRoute: _initialRoute,
        //routes: routes,
        onGenerateRoute: Routes.generateRoute,
        onUnknownRoute: Routes.errorRoute,
      ),
    );
  }
}