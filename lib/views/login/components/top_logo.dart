import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Hops/theme/style.dart';

class TopLogo extends StatelessWidget {

  double topPadding;
  TopLogo({ this.topPadding = 15.0 });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: topPadding),
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
          SizedBox(height: 10,),
          Center(child: Text("Descubre y compra", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),)),
          Text("cervezas artesanales locales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          SizedBox(height:70.0)
        ]
    );
  }
}
