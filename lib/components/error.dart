import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.error,
            size: 40,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Ups! Ocurrió un error."),
          ),
          Center(child: Text("Revisá tu conexión y volvé a intentarlo."))
        ],
      ),
    );
  }
}
