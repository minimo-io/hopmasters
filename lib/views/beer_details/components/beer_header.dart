import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/models/beer.dart';

import 'package:hopmasters/components/diagonally_cut_colored_image.dart';
import 'package:hopmasters/components/followers_info.dart';

class BeerHeader extends StatelessWidget{
  final beer;
  BeerHeader({
    @required Beer this.beer
  });

  Widget _buildBeerAvatar(){
    return new Align(
      alignment: FractionalOffset.bottomCenter,
      heightFactor: 1.4,
      child: new Column(
        children: <Widget>[
          Hero(
            tag: "beer-" + beer.name,
            child: Image.network( beer.image,
              height: 250,
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
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: ElevatedButton.icon(
                icon: Icon(Icons.favorite_border_outlined),
                label: Text(
                    "SEGUIR",
                    style: TextStyle(fontSize: 14)
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                    backgroundColor: MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: SECONDARY_BUTTON_COLOR)
                        )
                    )
                ),
                onPressed: () => null
            ),
          )
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
              "assets/images/beer-toast-bg-2.png",
              width: MediaQuery.of(context).size.width,
              height: 335.0,
              fit: BoxFit.cover,
            ),
            color: Color.fromRGBO(234, 186, 0, 0.4)
        ),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,
          child: new Column(
            children: <Widget>[
              _buildBeerAvatar(),
              FollowersInfo(this.beer.followers, textColor: SECONDARY_TEXT_DARK),
              _buildActionButtons(Theme.of(context)),
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