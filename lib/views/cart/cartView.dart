import 'package:flutter/material.dart';
import 'components/body.dart';


class CartView extends StatefulWidget{
  final String name;
  final int count;

  static const String routeName = "/cart";

  CartView({ this.name, this.count });

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Body(count: widget.count, name: widget.name),
      appBar: AppBar(
        title: Text("Carrito")
      ),
    );
  }
}