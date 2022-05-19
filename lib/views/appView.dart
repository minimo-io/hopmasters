import 'package:Hops/models/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/models/preferences.dart';
import 'package:Hops/models/loader.dart';

import 'package:Hops/components/search_button.dart';
import 'package:Hops/components/top_app_bar.dart';
import 'package:Hops/components/async_loader.dart';
import 'package:Hops/services/shared_services.dart';

import 'package:Hops/views/home/homeView.dart';
import 'package:Hops/views/store/storeView.dart';
import 'package:Hops/views/account/accountView.dart';
import 'package:Hops/views/favorites/favoritesView.dart';
import 'package:Hops/views/promos/promosView.dart';
import 'package:Hops/views/experiences/experiencesView.dart';


class AppView extends StatefulWidget {
  static const routeName = '/';

  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView>   {
  int currentTab = 0;
  static const String routeName = "/";
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // get preferences (beers, news, etc) and set them in provider for app use
    // beer_types
    SharedServices.populateProvider(context, "beer_types");
    // news_types
    SharedServices.populateProvider(context, "news_types");
  }


  List<Widget> pages =  <Widget>[
    HomeView(
    ),
    FavoritesView(),
    //ExperiencesView(),
    PromosView(),
    AccountView()
  ];


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
      icon: const Icon(Icons.redeem),
      label: "Promos",
    ),


    BottomNavigationBarItem(
      icon: const Icon(Icons.more_horiz),
      label: 'Más'
    ),

    /*

    BottomNavigationBarItem(
      icon: const Icon(Icons.place),
      label: "Experiencias",
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_circle),
      label: "Cuenta",
    ),

     */
  ];


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


  _onTapped(int index) {

    setState(() {
      currentTab = index;
    });
    pageController.jumpToPage(index);


  }


  void onPageChanged(int index) {
    setState(() {
      currentTab = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    // final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
                floatingActionButton: SearchButton(),
                appBar: TopAppBar(),
                body: PageView(
                  children: pages,
                  controller: pageController,
                  onPageChanged: onPageChanged,
                ),
                bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      gradient: PRIMARY_GRADIENT_COLOR,
                    ),
                    child: BottomNavigationBar(
                      elevation: 0,
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      backgroundColor: Colors.transparent,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: colorScheme.secondary.withOpacity(0.5),
                      selectedItemColor: colorScheme.secondary,

                      items: bottomNavigationBarItems,
                      currentIndex: currentTab,
                      //      selectedFontSize: textTheme.caption.fontSize,
                      //      unselectedFontSize: textTheme.caption.fontSize,
                      onTap: _onTapped,
                      /*
                      onTap: (int index) {
                        setState(() {
                          currentTab = index;
                        });
                      },

                       */
                    )

                  /*child:*/

                )
            );

  }
}

