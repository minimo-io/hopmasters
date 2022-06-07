import 'package:flutter/material.dart';

class HopsButton extends StatefulWidget {
  Text text;
  Icon icon;
  Function? doOnPressed;
  bool isGrey;
  Color bgColor;

  HopsButton(
      {required this.text,
      required this.icon,
      this.doOnPressed,
      this.isGrey = false,
      this.bgColor = Colors.black,
      Key? key})
      : super(key: key);

  @override
  _HopsButtonState createState() => _HopsButtonState();
}

class _HopsButtonState extends State<HopsButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: ElevatedButton.icon(
          icon: widget.icon,
          label: widget.text,
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5)),
              foregroundColor: MaterialStateProperty.all<Color>(
                  (widget.isGrey ? Colors.white70 : Colors.white)),
              backgroundColor: (widget.isGrey
                  ? MaterialStateProperty.all<Color>(
                      Colors.white24.withOpacity(.5))
                  : MaterialStateProperty.all<Color?>(widget.bgColor)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      side: (widget.isGrey
                          ? const BorderSide(style: BorderStyle.none)
                          : BorderSide(color: widget.bgColor))))),
          onPressed: widget.doOnPressed as void Function()?),
    );
  }
}
