import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/components/diagonally_cut_colored_image.dart';
import 'package:hopmasters/models/brewery.dart';
import 'package:meta/meta.dart';

class BreweryDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'assets/images/beer-toast-bg-2.png';

  BreweryDetailHeader(
    this.brewery, {
    @required this.avatarTag,
  });

  final Brewery brewery;
  final Object avatarTag;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 335.0,
        fit: BoxFit.cover,
      ),
      color: brewery.rgbColor.withOpacity(0.3)
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(brewery.avatar),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(brewery.followers.toString() + ' seguidores', style: TextStyle(color: Color(0xBBFFFFFF), fontSize: 18, fontWeight: FontWeight.bold), ),
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
                    backgroundColor: MaterialStateProperty.all<Color>(brewery.rgbColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: brewery.rgbColor)
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
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(theme),
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
