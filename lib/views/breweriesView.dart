import 'package:flutter/material.dart';

class breweriesView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: Text("Listado de cervecerías")),
      appBar: AppBar(
        title: Text("Cervecerías")
      )
    );
  }
}