import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class HopsNotifications{

  void message(BuildContext context, String notificationTitle){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text(notificationTitle),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
        action: SnackBarAction(
          textColor: colorScheme.background,
          label: "Ocultar",
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        ),
      );
  }

}