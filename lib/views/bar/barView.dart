import 'package:flutter/material.dart';

class BarView extends StatefulWidget {
  const BarView({Key? key}) : super(key: key);

  @override
  State<BarView> createState() => _BarViewState();
}

class _BarViewState extends State<BarView> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Bar View"));
  }
}
