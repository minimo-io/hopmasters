import 'package:flutter/material.dart';

class FavsTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ListView(
        shrinkWrap: true,
        children: [
          TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.storefront_rounded), text: "Cervecerías"),
                  Tab(icon: Icon(Icons.sports_bar_rounded), text: "Cervezas"),
                ],
          ),
          SizedBox(
              height:MediaQuery.of(context).size.height,
              child: TabBarView(
                children: [
                  Padding(padding: EdgeInsets.all(12), child: Text("Acá todas las cervecerías que seguís!")),
                  Padding(padding: EdgeInsets.all(12), child: Text("Y en esta tab todas tus cervezas favoritas")),
                ],
            ),
          ),
      ])
    );
  }
}
