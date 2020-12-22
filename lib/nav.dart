
import 'package:flutter/material.dart';

class Nav extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        "Nicolas",
      ),
      accountEmail: Text(
        "nicolas@minimo.io",
      ),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Text("Hopmasters")),
        )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context){

                            return Scaffold(
                                appBar: AppBar(
                                    title: Text("Saved Beers")
                                ),
                                body: ListView()
                            );
                          }
                      )
                  );

                },
                child: Icon(
                  Icons.shopping_cart,
                  size: 26.0,
                ),
              )
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            drawerHeader,
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        )
      ),
    );
  }

}