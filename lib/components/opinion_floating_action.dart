import 'package:flutter/material.dart';

class OpinionFloatingAction extends StatefulWidget {
  Color? bgColor = Colors.black54;
  Color? textColor = Colors.white;
  Null Function()? onTap;

  OpinionFloatingAction({
    this.textColor,
    this.bgColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _OpinionFloatingActionState createState() => _OpinionFloatingActionState();
}

class _OpinionFloatingActionState extends State<OpinionFloatingAction> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: widget.onTap,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
      label: Text('OPINAR', style: TextStyle(color:widget.textColor)),
      icon: Icon(Icons.edit, color: widget.textColor,),
      backgroundColor: widget.bgColor,
    );
  }
}
