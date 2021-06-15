import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/views/favorites/components/favoriteBreweries.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool? fixedScroll;

  final List<Widget> _tabs = [
    Tab(icon: Icon(Icons.storefront_rounded), text: "Cervecerías"),
    Tab(icon: Icon(Icons.sports_bar_rounded), text: "Cervezas"),
  ];

  _scrollListener() {
    if (fixedScroll != null) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: PRIMARY_GRADIENT_COLOR,
        ),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.black.withOpacity(0.3),
                  controller: _tabController,
                  //isScrollable: true,
                  tabs: _tabs,
                ),
              ),
            ];
          },
          body: Container(
            child: FutureBuilder(
                future: Future.wait([
                  SharedServices.loginDetails(),
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR);
                    default:
                      if (snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }else{
                        return Container(
                          height:MediaQuery.of(context).size.height,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: FavoriteBreweries(loginResponse: snapshot.data[0],),
                              ),
                              Padding(padding: EdgeInsets.all(12), child: Text("Y en esta tab todas tus cervezas favoritas")),
                            ],),
                        );
                      }
                  }

                }),
          ),
        ),
      ),
    );
  }
}

