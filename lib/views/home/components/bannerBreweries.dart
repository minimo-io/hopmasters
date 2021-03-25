import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

class BreweriesBanner extends StatelessWidget {
  const BreweriesBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(
        horizontal: (20),
        vertical: (15),
      ),
        /*
      decoration: BoxDecoration(
        color: PRIMARY_BUTTON_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      */
      decoration: BoxDecoration(
        color: SECONDARY_BUTTON_COLOR,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "Seguí a tus cervecerías favoritas\n"),
            TextSpan(
              text: "Ver ranking de cervecerías",
              style: TextStyle(
                fontSize: (24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}