import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

class OpinionFloatingAction extends StatefulWidget {
  String text;
  Color? bgColor = Colors.black54;
  Color? textColor = Colors.white;
  Null Function()? onTap;
  Widget? child;
  String? title;

  OpinionFloatingAction(
    this.text,
    {
    this.textColor,
    this.bgColor,
    this.onTap,
    this.child,
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  _OpinionFloatingActionState createState() => _OpinionFloatingActionState();
}

class _OpinionFloatingActionState extends State<OpinionFloatingAction> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (){
        Helpers.showPersistentBottomSheet(context, child: widget.child, title: widget.title);
        if (widget.onTap !=null) widget.onTap!();
      },
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
      label: Text(widget.text, style: TextStyle(color:widget.textColor)),
      icon: Icon(Icons.edit, color: widget.textColor,),
      backgroundColor: widget.bgColor,
    );
  }
}
