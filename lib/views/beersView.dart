import 'package:flutter/material.dart';

class beersView extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Cervezas")
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
        ),
      ),
    );
  }
}