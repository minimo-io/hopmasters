import 'package:flutter/material.dart';

class ScoreButton extends StatelessWidget {
  const ScoreButton({
    Key? key,
    required this.text,
    required this.image,
    this.press,
    this.contrast = "low",
  }) : super(key: key);

  final String text;
  final Image image;
  final VoidCallback? press;
  final String contrast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
      child: FlatButton(
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //color: Color(0xFFF5F6F9),
        color: (this.contrast == "high" ? Colors.black : Color(0xFFF5F6F9)),
        onPressed: press,
        child: Row(
          children: [
            image,
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: TextStyle(
                  color:
                      (this.contrast == "high" ? Colors.white : Colors.black)),
            )),
            // Icon(Icons.arrow_forward_ios,
            //     size: 15,
            //     color: (this.contrast == "high" ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}
