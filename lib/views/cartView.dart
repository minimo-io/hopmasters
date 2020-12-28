import 'package:flutter/material.dart';

class cartView extends StatelessWidget{
  final String name;
  final int count;

  cartView({ this.name, this.count });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: Text('Este es un carrito y tiene $count $name(s)')),
      appBar: AppBar(
        title: Text("Carrito")
      ),
    );
  }
}