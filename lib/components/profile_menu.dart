import 'package:flutter/material.dart';

class ProfileMenu extends StatefulWidget {
   ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    this.counterWidget,
  }) : super(key: key);


  final String text;
  final Icon icon;
  final VoidCallback? press;
  final Widget? counterWidget;

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: widget.press,
        child: Row(
          children: [
            widget.icon,
            SizedBox(width: 20),
            Expanded(child: Text(widget.text)),
            if (widget.counterWidget != null) widget.counterWidget!,
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );


  }
}