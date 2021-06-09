import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';


class BreweriesBanner extends StatelessWidget {
  const BreweriesBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal:20),
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
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/breweries",
          );
        }, // handle your image tap here
        child: Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: "Seguí a tus favoritas\n"),
              TextSpan(
                text: "Ranking de cervecerías",
                style: TextStyle(
                  fontSize: (21),
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}