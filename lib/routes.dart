import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/homeView.dart';
import 'package:hopmasters/views/cartView.dart';
import 'package:hopmasters/views/beersView.dart';
import 'package:hopmasters/views/breweriesView.dart';
import 'package:hopmasters/views/storeView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => homeView(),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
  "/beers": (BuildContext context) => new beersView(),
  "/breweries": (BuildContext context) => new breweriesView(),
  "/store": (BuildContext context) => new storeView(),
};