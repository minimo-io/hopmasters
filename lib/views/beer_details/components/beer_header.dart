import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/models/beer.dart';

import 'package:hopmasters/components/diagonally_cut_colored_image.dart';

class BeerHeader extends StatelessWidget{
  final beer;
  BeerHeader({
    @required Beer this.beer
  });


  Widget _buildBeerAvatar(){
    return new Align(
      alignment: FractionalOffset.bottomCenter,
      heightFactor: 1.2,
      child: new Column(
        children: <Widget>[
          Hero(
            tag: "beer-" + beer.name,
            child: Image.network( beer.image,
              height: 230,
              fit: BoxFit.fill,
              loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Stack(
      children: <Widget>[
        DiagonallyCutColoredImage(
            new Image.asset(
              "assets/images/65.jpg",
              width: MediaQuery.of(context).size.width,
              height: 335.0,
              fit: BoxFit.cover,
            ),
            //color: colorScheme.background.withOpacity(0.75)
            color: Color.fromRGBO(199, 199, 199, 0.9)
        ),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,
          child: new Column(
            children: <Widget>[
              _buildBeerAvatar(),
            ],
          ),
        ),
        /*
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
        */

      ],
    );
  }
}