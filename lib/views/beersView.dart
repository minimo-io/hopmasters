import 'package:flutter/material.dart';

class beersView extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Cervezas")
      ),
      body: Center(child: Text("Listado de cervezas por novedades y mas votadas"))
    );
  }
}