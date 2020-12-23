import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/homeView.dart';
import 'package:hopmasters/views/cartView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => homeView(),
  "/cart": (BuildContext context) => cartView(),
};