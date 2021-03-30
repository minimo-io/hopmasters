import 'package:flutter/material.dart';
import 'components/body.dart';


class cartView extends StatelessWidget{
  final String name;
  final int count;

  static const String routeName = "/cart";

  cartView({ this.name, this.count });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Body(count: count, name: name),
      appBar: AppBar(
        title: Text("Carrito")
      ),
    );
  }
}