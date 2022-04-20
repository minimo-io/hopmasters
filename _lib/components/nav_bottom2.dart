import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/nav_menu_provider.dart';
import 'package:Hops/theme/style.dart';





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

  final List<String> TabsRedirect = [
    "/",
    "/favs",
    "/store",
    "/account",
  ];




  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          gradient: PRIMARY_GRADIENT_COLOR,
        ),
        child: Consumer<NavMenuProvider>(
          builder: (context, menu, child){
            return BottomNavigationBar(
              elevation: 0,
              showUnselectedLabels: true,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: colorScheme.secondary.withOpacity(0.5),
              selectedItemColor: colorScheme.secondary,
              items: bottomNavigationBarItems,
              currentIndex: menu.currentIndex,
              //      selectedFontSize: textTheme.caption.fontSize,
              //      unselectedFontSize: textTheme.caption.fontSize,
              onTap: (index){

                // Navigator.pop(context);
                if (index != menu.currentIndex){
                  menu.setCurrentIndex(index);



                  Navigator.pushNamed(context, TabsRedirect[menu.currentIndex]);
                  RouteSettings settings = ModalRoute.of(context)!.settings;
                  print(settings);
                  //Navigator.pushReplacementNamed(context, TabsRedirect[menu.currentIndex]);

                  // Navigator.restorablePushNamed(context, TabsRedirect[menu.currentIndex]);

                  // go back in the stack to a desired route BUT we need to make sure it exits
                  /*
                  print(menu.items);
                  if (menu.items.contains(TabsRedirect[menu.currentIndex])){ // if it already has been accesed
                    //Navigator.removeRoute(context, route);

                    Navigator.popUntil(context, ModalRoute.withName( TabsRedirect[menu.currentIndex] ));
                    menu.remove(TabsRedirect[menu.currentIndex]);
                    print("Remove it");
                  }else{
                    Navigator.of(context).pushNamed(TabsRedirect[menu.currentIndex]);
                    menu.add(TabsRedirect[menu.currentIndex]);
                    print("Add it");
                  }
                  print(menu.items);
                  */
                }

              },
            );
          },
          /*child:*/
        )
    );
  }
}
