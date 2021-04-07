import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

class AsyncLoader extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child: Center(
                child: CircularProgressIndicator()
            ),
          )
      );
  }
}
