import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

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

    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: "Inicio",
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.sports_bar),
        label: "Cervezas",
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.store),
        label: "Cervecerías",
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.shopping_bag),
        label: "Tienda",
      ),
    ];

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
            icon: const Icon(Icons.search),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedItemColor: Colors.black,
        backgroundColor: colorScheme.primaryVariant,
        items: bottomNavigationBarItems,
        currentIndex: 0,
        selectedFontSize: textTheme.caption.fontSize,
        unselectedFontSize: textTheme.caption.fontSize,
      )
    );
  }

}