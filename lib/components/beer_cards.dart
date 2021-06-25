import 'package:flutter/material.dart';

import 'package:Hops/models/beer.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/helpers.dart';

import 'package:Hops/services/wordpress_api.dart';


class BeerCards extends StatefulWidget {
  List? beersList;
  String? loadingText;
  String? userBeersList; // possible favorite beers to call

  BeerCards({
    this.beersList,
    this.loadingText,
    this.userBeersList,
    Key? key
  }) : super(key: key);

  @override
  _BeerCardsState createState() => _BeerCardsState();
}

class _BeerCardsState extends State<BeerCards>{

  Future? _beers;

  @override
  void initState() {
    super.initState();

    if (widget.beersList != null){
        // in this case we already have the beer list, just build a future wait 0
      _beers =  Future.delayed(const Duration(seconds: 1), () => widget.beersList);
    }else{
      // else make the query
      _beers = WordpressAPI.getBeers(userBeers: widget.userBeersList!);
    }

  }



  @override
  Widget build(BuildContext context) {

    Widget _buildBottomItem(Beer beer) {
      return GestureDetector(
        onTap: (){
          Navigator.pushNamed(
          context,
          "/beer",
          arguments: { 'beerId': int.parse(beer.beerId) },

          );
        },
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, right: 8),
                          child: Icon(Icons.favorite_border, color: colorScheme.secondaryVariant.withOpacity(0.5)),
                        )),
                    Expanded(
                      child: Image.network(beer.image!, height: 200),
                    ),
                    Container(child: Padding(padding: EdgeInsets.only(top:10.0)),),
                    Text(
                      beer.name!,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "\$${beer.price}",
                      style: TextStyle(fontSize: 11),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 4),
                    child: Text(
                      'NUEVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  color: Colors.pinkAccent.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }


    Widget _buildBeerList(List<dynamic> beersList){
      var beersBottom = (beersList as List)
          .map((data) => new Beer.fromJson(data))
          .toList();

      //List<Widget> beerCardList = new List<Widget>();
      List<Widget> beerCardList = <Widget>[];
      for(var i = 0; i < beersBottom.length; i++){
          beerCardList.add( _buildBottomItem(beersBottom[i]) );

      }

      if ( beersBottom.length > 0){
        // define size
        final double itemHeight = 270;
        final double itemWidth = MediaQuery.of(context).size.width / 2;


        return GridView.count(
            scrollDirection: Axis.vertical,
            childAspectRatio: (itemWidth / itemHeight),

            crossAxisCount: 2,
            children: beerCardList,

        );


        //return Expanded(child: Column(children: beerCardList));
      }else{
        return Center(

            child: Container(
              padding: EdgeInsets.all(8.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ninguna cervezas todavía", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5.0),
                  Text("¿Conoces alguna?"),
                  SizedBox(height: 5.0),
                  RaisedButton.icon(
                    label: Text("Ponete en contacto"),
                    icon: Icon(Icons.send),
                    onPressed: () => Helpers.launchURL("https://hops.uy/contacto/"),
                  )
                ]
              ),
            )
        );
      }

    }



    return Container(
      color: Colors.transparent,
      //height: MediaQuery.of(context).size.height * 0.60,
      height: 270 * 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: marginSide),
        child: FutureBuilder(
          future: _beers,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,),

                    if (widget.loadingText != null) Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(widget.loadingText!))


                  ],
                ));
              default:
                return _buildBeerList(snapshot.data);
            }
          }
        ),
      ),
    );

  }
}