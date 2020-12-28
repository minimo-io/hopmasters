import 'package:flutter/material.dart';

class breweriesView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: Text("Invitados por Mandy Goldberg <mandy@4kingmedia.com> de Betchain.")),
      appBar: AppBar(
        title: Text("Cervecerías")
      )
    );
  }
}