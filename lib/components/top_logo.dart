import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Hops/theme/style.dart';

class TopLogo extends StatelessWidget {

  double topPadding, bottomPadding;
  bool showSlogan;
  String title;
  TopLogo({
    this.topPadding = 15.0,
    this.bottomPadding = 70.0,
    this.showSlogan = true,
    this.title = "Hops"
  });

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                padding: EdgeInsets.only(top: 15.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this.title,
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
            ),
          ),
          SizedBox(height: 10,),
          if (this.showSlogan) Center(child: Text("Descubre y compra", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),)),
          if (this.showSlogan) Text("cervezas artesanales locales", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          SizedBox(height:this.bottomPadding)
        ]
    );
  }
}
