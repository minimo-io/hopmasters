import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class HopsNotifications{

  void message(BuildContext context, String notificationTitle, { String action = "hideSnackBar", Function? callback }){

    String _buildLabel(String action){
      String label = "Ocultar";
      if (action == "hideSnackBar") label = "Ocultar";
      if (action == "goToCart") label = "Ir al carrito";
      if (action == "goToOrders") label = "Ver pedidos";

      return label;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text(notificationTitle),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0,
        action: SnackBarAction(
          textColor: colorScheme.background,
          label: _buildLabel(action),
          onPressed: (){
            if (action == "hideSnackBar") ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (action == "goToOrders"){
              /*
              Navigator.pushNamed(
                context,
                "orders",
              );*/

            }
            if (action == "goToCart"){
              /*
              Navigator.pushNamed(
                context,
                "/cart",
              );
              */
            }
            if (callback != null) callback();
          },
        ),
        ),
      );
  }

}