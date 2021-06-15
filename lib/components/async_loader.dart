import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class AsyncLoader extends StatelessWidget{
  String? text;

  AsyncLoader({ this.text });

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR)
                ),
                if (this.text != null) Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(this.text!),
                )
              ],
            ),
          )
      );
  }
}
