import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/theme/style.dart';

class StarsScore extends StatefulWidget {
  int opinionCount = 0;
  double opinionScore = 0.0;
  bool onlyStars;
  double starSize;
  double textSize;
  double textTopPadding;

  StarsScore(
      {
        required this.opinionCount,
        required this.opinionScore,
        this.onlyStars = false,
        this.starSize = 25.0,
        this.textSize = 14.0,
        this.textTopPadding = 0,
        Key? key
  }) : super(key: key);

  @override
  _StarsScoreState createState() => _StarsScoreState();
}

class _StarsScoreState extends State<StarsScore> {

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            SizedBox(
              width: 8.0,
            ),
            Icon(Icons.star, color: (widget.opinionScore >= 1 ? SECONDARY_BUTTON_COLOR : colorScheme.background ), size: widget.starSize,),
            Icon(Icons.star, color: (widget.opinionScore >= 2 ? SECONDARY_BUTTON_COLOR : colorScheme.background ), size: widget.starSize,),
            Icon(Icons.star, color: (widget.opinionScore >= 3 ? SECONDARY_BUTTON_COLOR : colorScheme.background ), size: widget.starSize,),
            Icon(Icons.star, color: (widget.opinionScore >= 4 ? SECONDARY_BUTTON_COLOR : colorScheme.background ), size: widget.starSize,),
            Icon(Icons.star, color: (widget.opinionScore >= 5 ? SECONDARY_BUTTON_COLOR : colorScheme.background ), size: widget.starSize,),
            SizedBox(
              width: Helpers.screenAwareSize(5.0, context),
            ),
          ],
        ),
        if (widget.onlyStars == false) Padding(
          padding: EdgeInsets.only(right:10.0, top: widget.textTopPadding),
          child: Text(
            widget.opinionCount.toString() + " " + (widget.opinionCount == 1 ? "opinión" : "opiniones" ) ,
            style: TextStyle(color: Colors.black54, fontSize: widget.textSize),
          ),
        )

      ],
    );
  }
}
