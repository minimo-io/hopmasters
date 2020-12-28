import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/homeView.dart';
import 'package:hopmasters/views/cartView.dart';
import 'package:hopmasters/views/breweriesView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => homeView(),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
  "/breweries": (BuildContext context) => new breweriesView(),
};