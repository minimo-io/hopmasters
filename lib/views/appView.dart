import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/models/preferences.dart';

import 'package:Hops/components/search_button.dart';
import 'package:Hops/components/top_app_bar.dart';

import 'package:Hops/services/shared_services.dart';

import 'package:Hops/views/home/homeView.dart';
import 'package:Hops/views/store/storeView.dart';
import 'package:Hops/views/account/accountView.dart';
import 'package:Hops/views/favorites/favoritesView.dart';


class AppView extends StatefulWidget {
  static const routeName = '/';
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {


  @override
  void initState() {
    super.initState();

    // get preferences (beers, news, etc) and set them in provider for app use
      // beer_types
    SharedServices.populateProvider(context, "beer_types");
      // news_types
    SharedServices.populateProvider(context, "news_types");
  }

  final List<Widget> pages = const <Widget>[
    HomeView(
      key: PageStorageKey<String>('page1'),
    ),
    FavoritesView(
      key: PageStorageKey<String>('page2'),
    ),
    StoreView(
      key: PageStorageKey<String>('page3'),
    ),
    AccountView(
      key: PageStorageKey<String>('page4'),
    )
  ];

  int currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

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

  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {


    // final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        floatingActionButton: SearchButton(),
        appBar: TopAppBar(),
        body: PageStorage(
          child: pages[currentTab],
          bucket: _bucket,
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child: BottomNavigationBar(
                  elevation: 0,
                  showUnselectedLabels: true,
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  unselectedItemColor: colorScheme.secondary.withOpacity(0.5),
                  selectedItemColor: colorScheme.secondary,
                  items: bottomNavigationBarItems,
                  currentIndex: currentTab,
                  //      selectedFontSize: textTheme.caption.fontSize,
                  //      unselectedFontSize: textTheme.caption.fontSize,
                  onTap: (int index) {
                    setState(() {
                      currentTab = index;
                    });
                  },
                )

              /*child:*/

        )
    );
  }
}

