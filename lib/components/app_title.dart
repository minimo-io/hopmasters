import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class AppTitle extends StatelessWidget {
  final String? subtitle, title;
  double? horizontalPadding;
  AppTitle({this.subtitle, this.title, this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    Widget button;
    //var checkTitle = this.title;

    button = Padding(
        padding:
            EdgeInsets.symmetric(horizontal: this.horizontalPadding ?? 33.0),
        child: Text(
          this.subtitle ?? "",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13.0,
            color: colorScheme.secondary,
          ),
        ));

    if (this.title != null) {
      button = Padding(
          padding:
              EdgeInsets.symmetric(horizontal: this.horizontalPadding ?? 33.0),
          child: Text(
            this.title ?? "",
            // textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: titlesLeftSize,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ));
    }

    return button;
  }
}
