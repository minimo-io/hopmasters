import 'package:flutter/material.dart';
import 'components/body.dart';


class cartView extends StatefulWidget{
  final String name;
  final int count;

  static const String routeName = "/cart";

  cartView({ this.name, this.count });

  @override
  _cartViewState createState() => _cartViewState();
}

class _cartViewState extends State<cartView> {
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