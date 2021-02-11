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
      icon: const Icon(Icons.favorite),
      label: "Favoritas",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_cart),
      label: "Tienda",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.room),
      label: "Bares",
    ),
  ];

  List<String> TabsRedirect = [
    "/",
    "/favorites",
    "/store",
    "/bars",
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
      backgroundColor: colorScheme.background,
      items: bottomNavigationBarItems,
      currentIndex: currentNavigationTabIndex,
      selectedFontSize: textTheme.caption.fontSize,
      unselectedFontSize: textTheme.caption.fontSize,
      onTap: onTapped,
    );
  }
}