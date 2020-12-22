import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import './nav.dart';

class TopBeers extends StatefulWidget{
  @override
  TopBeersState createState() => TopBeersState();
}

class TopBeersState extends State<TopBeers>{

  final _randomWordPairs = <WordPair>[];
  final _savedBeers = Set<WordPair>();

  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item){
        if (item.isOdd) return Divider();
        final index = item ~/2;
        if (index >= _randomWordPairs.length){
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _savedBeers.contains(pair);
    return ListTile(
        title: Text(pair.asPascalCase, style: TextStyle(fontSize:18.0)),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border, color: alreadySaved ? Colors.red : null),
        onTap: (){
           setState(() {
             if (alreadySaved){
               _savedBeers.remove(pair);
             }else{
               _savedBeers.add(pair);
             }
           });
        }
    );
  }
  // actual navigator class & routing usage
  // https://api.flutter.dev/flutter/widgets/Navigator-class.html
  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          final Iterable<ListTile> tiles = _savedBeers.map((WordPair pair){
            return ListTile(
              title: Text(pair.asPascalCase, style: TextStyle(fontSize:16.0))
            );
          });
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Beers")
            ),
            body: ListView(children: divided)
          );
        }
      )
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text( 'Hopmasters' ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.list),
                onPressed: _pushSaved
              )
            ]
        ),
        body: _buildList()

    );
  }


}