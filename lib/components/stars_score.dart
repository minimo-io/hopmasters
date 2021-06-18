import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/theme/style.dart';

class StarsScore extends StatefulWidget {
  const StarsScore({Key? key}) : super(key: key);

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
            Icon(Icons.star, color: SECONDARY_BUTTON_COLOR),
            Icon(Icons.star, color: SECONDARY_BUTTON_COLOR),
            Icon(Icons.star, color: colorScheme.background),
            Icon(Icons.star, color: colorScheme.background),
            Icon(Icons.star, color: colorScheme.background),
            SizedBox(
              width: Helpers.screenAwareSize(5.0, context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: Text(
            '378 votos',
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
          ),
        )
      ],
    );
  }
}
