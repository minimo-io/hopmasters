import 'package:flutter/material.dart';

class ScoreMiniButton extends StatelessWidget {
  const ScoreMiniButton({
    Key? key,
    required this.text,
    required this.image,
    this.press,
  }) : super(key: key);

  final String text;
  final Image image;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      child: Row(
        children: [
          image,

          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13),)),
        ],
      ),
    );
  }
}