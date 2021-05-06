import 'package:flutter/material.dart';

import 'package:hopmasters/models/beer.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';

class BeerCards extends StatefulWidget {
  List beersList;

   BeerCards({
    this.beersList,
    Key key
  }) : super(key: key);

  @override
  _BeerCardsState createState() => _BeerCardsState();
}

class _BeerCardsState extends State<BeerCards> {
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
                      child: Image.network(beer.image),
                    ),
                    Container(child: Padding(padding: EdgeInsets.only(top:10.0)),),
                    Text(
                      beer.name,
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

    Widget _buildBeerList(){
      var beersBottom = (widget.beersList as List)
          .map((data) => new Beer.fromJson(data))
          .toList();

      List<Widget> beerCardList = new List<Widget>();
      for(var i = 0; i < beersBottom.length; i++){
          beerCardList.add( _buildBottomItem(beersBottom[i]) );

      }

      /*return GridView(children: beerCardList);*/
      return GridView.count(
        crossAxisCount: 2,
          children: beerCardList
      );
    }



    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.29,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: marginSide),
        child: _buildBeerList(),
      ),
    );

  }
}