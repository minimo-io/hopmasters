import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class AppTitle extends StatelessWidget {

  final String subtitle, title;
  AppTitle({ this.subtitle, this.title });


  @override
  Widget build(BuildContext context) {
    if (this.subtitle != null){
      return Padding(
          padding:const EdgeInsets.symmetric( horizontal: 33.0 ),
          child: Text(
            this.subtitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13.0,
              color: colorScheme.secondary,
            ),
          )
      );
    }
    if (this.title != null){
      return Padding(
          padding:const EdgeInsets.symmetric( horizontal: 33.0 ),
          child: Text(
            this.title,
            // textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          )
      );
    }
  }
}
