import 'package:flutter/widgets.dart';
import 'package:hopmasters/views/appView.dart';
import 'package:hopmasters/views/cart/cartView.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => AppView(),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
};