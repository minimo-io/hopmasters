import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // Esto tambien se puede escribir void main(){} => runApp();

  runApp(
      MyApp()); // Le paso el constructor del widget "Myapp" el cual debo definirlo abajo. Fuera del main

  // EJEMPLO 1 RunApp
  /*runApp(Center( // Esta funcion recibe como parametro un widget. En Flutter los objetos son widgets. La aplicacion en si es in widget
     child:Text(
        "Hello World",
       textDirection: TextDirection.ltr,
     ),

    )
  );*/
}

class MyApp extends StatelessWidget {
  // Los widget siempre deben tener un metodo build

  @override
  Widget build(BuildContext context) {
    // Retorna un widget y recibe como parametro un objeto buildContext
    return MaterialApp(
      title: "Hi!",
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter App')),
        body: Center(child: Text("Hello moto")),
      ), // widget del inicio de la aplicacion. "Scaffold" trae por defecto cierto diseÃ±o
    );
  }
}
