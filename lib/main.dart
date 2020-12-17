import 'package:flutter/material.dart';
import './top_beers.dart';

const String _appTitle = "Hopmasters";

void main() => runApp(HopmastersApp());

class HopmastersApp extends StatelessWidget{

  @override
  // The override is not required but nice to specify
  // All classes have a build() so we override it
  Widget build(BuildContext context){
    // this is from the material package.
    // more docs here: https://api.flutter.dev/flutter/material/MaterialApp-class.html
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.amber
        ),
        home: TopBeers()
    );
  }
}