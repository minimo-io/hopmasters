import 'package:Hops/constants.dart';
import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/views/favorites/components/favoriteBreweries.dart';
import 'package:Hops/views/favorites/components/favoriteBeers.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool? fixedScroll;
  LoginResponse? _userData;
  Future? _loginFuture;

  final List<Widget> _tabs = [
    Tab(
        key: UniqueKey(),
        icon: const Icon(Icons.storefront_rounded),
        text: "Cervecerías"),
    Tab(
        key: UniqueKey(),
        icon: const Icon(Icons.sports_bar_rounded),
        text: "Cervezas"),
  ];

  _scrollListener() {
    if (fixedScroll != null) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController =
        TabController(length: _tabs.length, vsync: this, initialIndex: 0);

    _loginFuture = getUserData();
  }

  Future? getUserData() async {
    _userData = await SharedServices.loginDetails();

    return _userData;
  }

/*
  @override
  void dispose() {
    //_tabController.dispose();
    //_scrollController.dispose();
    //super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: PRIMARY_GRADIENT_COLOR,
        ),
        child: NestedScrollView(
          controller: _scrollController,
          //physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: TabBar(
                  key: UniqueKey(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black.withOpacity(0.3),
                  controller: _tabController,
                  //isScrollable: true,
                  tabs: _tabs,
                ),
              ),
            ];
          },
          body: FutureBuilder(
              future: _loginFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator(
                        color: PROGRESS_INDICATOR_COLOR);
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          key: UniqueKey(),
                          controller: _tabController,
                          children: [
                            RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  _loginFuture = getUserData();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: FavoriteBreweries(
                                    key: UniqueKey(),
                                    loginResponse: snapshot.data),
                              ),
                            ),
                            RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  _loginFuture = getUserData();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: FavoriteBeers(
                                    key: UniqueKey(),
                                    loginResponse: snapshot.data),
                              ),
                            ),
                            //Padding(padding: EdgeInsets.all(12), child: Text("Y en esta tab todas tus cervezas favoritas")),
                          ],
                        ),
                      );
                    }
                }
              }),
        ),
      ),
    );
  }
}
