import 'package:flutter/material.dart';

import 'package:Hops/models/brewery.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/components/text_expandable.dart';
import 'package:Hops/components/stars_score.dart';


class BreweryDetailBody extends StatelessWidget {
  BreweryDetailBody(this.brewery);
  final Brewery? brewery;

  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: SECONDARY_TEXT_DARK,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            brewery!.location!,
            style: TextStyle(color: SECONDARY_TEXT_DARK.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 1.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: (color == Colors.white12 ? Colors.black : Colors.white ) ,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  brewery!.name!,
                  style: TextStyle(color:SECONDARY_TEXT_DARK, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: _buildLocationInfo(textTheme),
                ),
              ],),

            InkWell(
                onTap: (){
                  Navigator.pushNamed(
                    context,
                    "/comments",
                    arguments: {'postId': int.parse(this.brewery!.id), 'postTitle': this.brewery!.name },
                  );
                },
                child: StarsScore()
            )

          ],
        ),

        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          // child: ExpandableText(brewery!.description),
          child: TextExpandable(
            brewery!.description!,
          )
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.sports_bar, brewery!.rgbColor),
//              _createCircleBadge(Icons.cloud, Colors.white12),
//              _createCircleBadge(Icons.shop, Colors.white12),
              Padding( padding: EdgeInsets.only(left:6.0), child: Text(brewery!.beersCount.toString() + " cervezas"))
            ],
          ),
        ),
      ],
    );
  }
}
