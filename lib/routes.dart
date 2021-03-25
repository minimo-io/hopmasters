import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/home/homeView.dart';
import 'package:hopmasters/views/cartView.dart';
import 'package:hopmasters/views/beersView.dart';
import 'package:hopmasters/views/breweriesView.dart';
import 'package:hopmasters/views/storeView.dart';
import 'package:hopmasters/views/favorites/favoritesView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => homeView(),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
  "/beers": (BuildContext context) => new beersView(),
  "/breweries": (BuildContext context) => new breweriesView(),
  "/favs": (BuildContext context) => new FavoritesView(),
  "/store": (BuildContext context) => new storeView(),
};