import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class AppTitle extends StatelessWidget {

  final String? subtitle, title;
  AppTitle({ this.subtitle, this.title });


  @override
  Widget build(BuildContext context) {
    Widget button;
    //var checkTitle = this.title;

    button = Padding(
        padding:const EdgeInsets.symmetric( horizontal: 33.0 ),
        child: Text(
          this.subtitle ?? "",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13.0,
            color: colorScheme.secondary,
          ),
        )
    );

    if (this.title != null){
      button = Padding(
          padding:const EdgeInsets.symmetric( horizontal: 33.0 ),
          child: Text(
            this.title ?? "",
            // textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          )
      );
    }

    return button;
  }
}
