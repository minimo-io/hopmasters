import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/routes.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/login.dart';

// providers
import 'package:Hops/models/nav_menu_provider.dart';
import 'package:Hops/models/category.dart';


String _initialRoute = "login";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedServices.isLoggedIn();

  if (_result){
    _initialRoute = "/";
  }
  runApp(HopsApp());
}

class HopsApp extends StatelessWidget{
  @override
  // The override is not required but nice to specify
  // All classes have a build() so we override it
  Widget build(BuildContext context){
    // this is from the material package.
    // more docs here: https://api.flutter.dev/flutter/material/MaterialApp-class.html
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (context) => NavMenuProvider(), ),
        ChangeNotifierProvider( create: (context) => Preferences(), ),
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