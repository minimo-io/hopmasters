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
      label: "Descubrir",
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
      icon: const Icon(Icons.account_circle),
      label: "Cuenta",
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
    return Container(
        decoration: BoxDecoration(
          gradient: PRIMARY_GRADIENT_COLOR,
        ),
        child:BottomNavigationBar(
          elevation: 0,
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: colorScheme.secondary.withOpacity(0.5),
          selectedItemColor: colorScheme.secondary,
          items: bottomNavigationBarItems,
          currentIndex: currentNavigationTabIndex,
//      selectedFontSize: textTheme.caption.fontSize,
//      unselectedFontSize: textTheme.caption.fontSize,
          onTap: onTapped,
        )
    );
  }
}