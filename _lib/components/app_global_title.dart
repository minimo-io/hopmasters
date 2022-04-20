// like App_title.dart but better
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class AppGlobalTitle extends StatelessWidget {

  final String? title, type;
  AppGlobalTitle({  this.title, this.type = "title" });


  @override
  Widget build(BuildContext context) {
    Widget button;
    //var checkTitle = this.title;

    TextStyle titleStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: colorScheme.secondary,
    );

    if (type == "subtitle"){
      titleStyle = TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w300,
        color: colorScheme.secondary,
      );
    }

    button = Padding(
        padding:const EdgeInsets.symmetric( horizontal: 12.0 ),
        child: Text(
          this.title ?? "",
          // textAlign: TextAlign.start,
          style: titleStyle,
        )
    );

    return button;
  }
}
