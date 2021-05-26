import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hopmasters/theme/style.dart';

class TopLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0),
            child: Center(
                child: Image.asset("assets/images/hops-logo.png", height: 60,)
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Hops",
                  style: GoogleFonts.russoOne(
                      textStyle: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 32.0,
                      )
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height:70.0)
        ]
    );
  }
}
