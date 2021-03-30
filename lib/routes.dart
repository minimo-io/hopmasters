import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/home/homeView.dart';
import 'package:hopmasters/views/store/storeView.dart';
import 'package:hopmasters/views/account/accountView.dart';
import 'package:hopmasters/views/favorites/favoritesView.dart';

import 'package:hopmasters/views/cart/cartView.dart';
//import 'package:hopmasters/views/beersView.dart';
// import 'package:hopmasters/views/breweriesView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => homeView(),
  "/favs": (BuildContext context) => new FavoritesView(),
  "/store": (BuildContext context) => new StoreView(),
  "/account": (BuildContext context) => new AccountView(userID: '231'),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
  // "/beers": (BuildContext context) => new beersView(),
  // "/breweries": (BuildContext context) => new breweriesView(),
};