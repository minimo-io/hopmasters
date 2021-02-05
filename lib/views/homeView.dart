import 'package:flutter/material.dart';
import 'package:hopmasters/components/nav_bottom.dart';

class homeView extends StatelessWidget{
  homeView({Key key}) : super(key: key);

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
        centerTitle: false,
        title: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Text("Hopmasters")),
        )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Carrito',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Buscar',
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              drawerHeader,
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Mensajes'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Perfil'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración'),
              ),
              ListTile(
                leading: Icon(Icons.article),
                title: Text('Blog'),
              ),
            ],
          )
      ),
      bottomNavigationBar: new NavBottom(),
      body: Center(child: Text("La pantalla principal"))
    );
  }

}