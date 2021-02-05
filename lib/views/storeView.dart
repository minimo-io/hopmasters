import 'package:flutter/material.dart';

class storeView extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
            title: Text("Tienda")
        ),
        body: Center(child: Text("Un listado de las cervezas disponibles para comprar!"))
    );
  }
}