import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/theme/style.dart';

class StarsScore extends StatefulWidget {
  int opinionCount = 0;
  double opinionScore = 0.0;

  StarsScore(
      {
        required this.opinionCount,
        required this.opinionScore,
        Key? key
  }) : super(key: key);

  @override
  _StarsScoreState createState() => _StarsScoreState();
}

class _StarsScoreState extends State<StarsScore> {
  /*
  int _opinionCount = 0;
  double _opinionScore = 0.0;

  @override
  void initState(){
    _opinionCount = widget.opinionCount;
    _opinionScore = widget.opinionScore;

  }
  */
  @override
  Widget build(BuildContext context) {

    print("OPINION COUNT : " + widget.opinionCount.toString() );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            SizedBox(
              width: 8.0,
            ),
            Icon(Icons.star, color: (widget.opinionScore >= 1 ? SECONDARY_BUTTON_COLOR : colorScheme.background )),
            Icon(Icons.star, color: (widget.opinionScore >= 2 ? SECONDARY_BUTTON_COLOR : colorScheme.background )),
            Icon(Icons.star, color: (widget.opinionScore >= 3 ? SECONDARY_BUTTON_COLOR : colorScheme.background )),
            Icon(Icons.star, color: (widget.opinionScore >= 4 ? SECONDARY_BUTTON_COLOR : colorScheme.background )),
            Icon(Icons.star, color: (widget.opinionScore >= 5 ? SECONDARY_BUTTON_COLOR : colorScheme.background )),
            SizedBox(
              width: Helpers.screenAwareSize(5.0, context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: Text(
            widget.opinionCount.toString() + " " + (widget.opinionCount == 1 ? "opinión" : "opiniones" ) ,
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        )
      ],
    );
  }
}
