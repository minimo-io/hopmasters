import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/services/shared_services.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/routes.dart';
import 'package:provider/provider.dart';
import 'package:hopmasters/models/nav_menu_provider.dart';

String _initialRoute = "/login";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedServices.isLoggedIn();
  if (_result){
    _initialRoute = "/";
  }
  runApp(HopmastersApp());
}

class HopmastersApp extends StatelessWidget{
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