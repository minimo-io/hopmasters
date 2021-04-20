import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/components/beer.dart';


class BeerCards extends StatelessWidget {
  const BeerCards({
    Key key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Widget _buildBottomItem(Beer beer) => Card(
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
                  child: Image.asset(beer.image),
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
    );

    const beersBottom = [
      const Beer(
          name: 'Avante Supernauta',
          type: "Hazy Sour IPA",
          abv: 8,
          price: 170.00,
          image: dummyBeerImagePath),
      const Beer(
          name: 'Mastra Strong',
          type: "Strong Pale Ale",
          abv: 6,
          price: 130.00,
          image: dummyBeerImagePath2)
    ];

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.29,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: marginSide),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: _buildBottomItem(beersBottom.first),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _buildBottomItem(beersBottom.last),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}