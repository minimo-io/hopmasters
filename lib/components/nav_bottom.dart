import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

class NavBottom extends StatefulWidget{

  @override
  _NavBottomState createState() => _NavBottomState();

}

class _NavBottomState extends State<NavBottom>{
  int currentNavigationTabIndex = 0;


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
      icon: const Icon(Icons.room),
      label: "Cervecerías",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.local_drink),
      label: "Bares",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_bag),
      label: "Tienda",
    ),
  ];

  List<String> TabsRedirect = [
    "/",
    "/beers",
    "/breweries",
    "/bars",
    "/store"
  ];

  void onTapped(int index){
    Navigator.pushNamed(context, TabsRedirect[index]);
    setState(() {
      currentNavigationTabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      selectedItemColor: Colors.black,
      backgroundColor: colorScheme.primaryVariant,
      items: bottomNavigationBarItems,
      currentIndex: currentNavigationTabIndex,
      selectedFontSize: textTheme.caption.fontSize,
      unselectedFontSize: textTheme.caption.fontSize,
      onTap: onTapped,
    );
  }
}