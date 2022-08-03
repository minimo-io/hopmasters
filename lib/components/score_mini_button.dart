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
    return InkWell(
      onTap: press,
      child: SizedBox(
        width: 72,
        child: Row(
          children: [
            image,
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              (text.isEmpty ? "0" : text),
              style: const TextStyle(fontSize: 13),
            )),
          ],
        ),
      ),
    );
  }
}
