import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/diagonally_cut_colored_image.dart';
import 'package:Hops/utils/load_network_image.dart';
import 'package:Hops/components/followers_info.dart';

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
            child: LoadNetworkImage(uri: beer.image, height: 230,),
          ),
        ],
      ),
    );
  }

  Widget _buildBeerPrice(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("\$" + this.beer.price,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {

    Widget _buildButton({Text text, Icon icon}){
        return ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: ElevatedButton.icon(
              icon: icon,
              label: text,
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(beer.rgbColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: beer.rgbColor)
                      )
                  )
              ),
              onPressed: () => null
          ),
        );
      /*
        return ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: Container(
            color: SECONDARY_BUTTON_COLOR,
            child: new IconButton(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                iconSize: 20,
                icon: icon,
                onPressed: null),
          ),
        );
      */
    }

    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 2),
              child:_buildButton(text: Text("FAVORITA"), icon:  Icon(Icons.favorite_border_outlined))
          ),
          Padding(
              padding: EdgeInsets.only(left:2),
              child: _buildButton(text: Text("COMPRAR"), icon: Icon(Icons.shopping_cart))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Stack(
      children: <Widget>[
        DiagonallyCutColoredImage(
            new Image.asset(
              "assets/images/beer_bg_bw2.png",
              width: MediaQuery.of(context).size.width,
              height: 440,
              fit: BoxFit.cover,
            ),
            //color: colorScheme.background.withOpacity(0.75)
            color: beer.rgbColor.withOpacity(0.35)
        ),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,
          child: new Column(
            children: <Widget>[
              _buildBeerAvatar(),
              _buildBeerPrice(),
              //FollowersInfo(this.beer.followers, textColor: SECONDARY_TEXT_DARK),
              _buildActionButtons(Theme.of(context)),
            ],
          ),
        ),

        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),


      ],
    );
  }
}