import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:Hops/models/brewery.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/components/text_expandable.dart';
import 'package:Hops/components/stars_score.dart';

class BreweryDetailBody extends StatelessWidget {
  BreweryDetailBody(this.brewery, {this.scores});

  final Brewery? brewery;
  Map<String, dynamic>? scores;

  Widget _buildLocationInfo(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.place,
          color: SECONDARY_TEXT_DARK,
          size: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            brewery!.location!,
            style: TextStyle(color: SECONDARY_TEXT_DARK.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color,
      {double size = 16.0}) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0),
      child: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          iconData,
          color: (color == Colors.white12 ? Colors.black : Colors.white),
          size: size,
        ),
        radius: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brewery!.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: SECONDARY_TEXT_DARK,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: _buildLocationInfo(textTheme),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/comments",
                    arguments: {
                      'postId': int.parse(this.brewery!.id),
                      'postTitle': this.brewery!.name
                    },
                  );
                },
                child: StarsScore(
                  opinionCount: this.scores!["opinionCount"],
                  opinionScore: this.scores!["opinionScore"],
                ))
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(top: 16.0),
            // child: ExpandableText(brewery!.description),
            child: TextExpandable(
              brewery!.description!,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: <Widget>[
              _createCircleBadge(Icons.sports_bar, brewery!.rgbColor, size: 10),
//              _createCircleBadge(Icons.cloud, Colors.white12),
//              _createCircleBadge(Icons.shop, Colors.white12),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  brewery!.beersCount.toString() + " cerveza(s)",
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              if (brewery!.isHopsClient == "1")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    _createCircleBadge(Icons.done, Colors.green, size: 10),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Text("Vende en Hops", style: TextStyle(fontSize: 12)),
                  ],
                ),

              if (brewery!.isHopsClient == "0")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    _createCircleBadge(Icons.close, Colors.redAccent, size: 10),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Text("Todavía no vende en Hops",
                        style: TextStyle(fontSize: 12)),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
