import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  String text;
  IconData icon;

  AlertBox({
    this.text = "",
    this.icon = Icons.info,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(

        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 243, 205, 1),
            border: Border.all(
                color: Color.fromRGBO(255, 243, 205, 1)
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          children: [
            Icon(
              this.icon,
              color: Color.fromRGBO(102, 77, 3, 1),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Container(
                child: Text(this.text,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color.fromRGBO(102, 77, 3, 1)
                    )),
              ),
            )
          ],
        )
    );

  }
}
