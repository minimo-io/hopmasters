import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

const String _appTitle = "Hopmasters";

void main() => runApp(HopmastersApp());

class HopmastersApp extends StatelessWidget{

  @override
  // The override is not required but nice to specify
  // All classes have a build() so we override it
  Widget build(BuildContext context){
    final wordPair = WordPair.random();
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

class TopBeers extends StatefulWidget{
  @override
  TopBeersState createState() => TopBeersState();
}

class TopBeersState extends State<TopBeers>{
  Widget _buildList(){
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }

   Widget build(BuildContext context){
     return Scaffold(
         appBar: AppBar( title: Text( _appTitle + ' Top Beers' ) ),
         body: _buildList()

     );
   }
}