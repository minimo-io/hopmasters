import 'package:flutter/material.dart';

import 'package:hopmasters/views/appView.dart';
import 'package:hopmasters/views/cart/cartView.dart';
import 'package:hopmasters/views/brewery_details/breweryView.dart';
import 'package:hopmasters/views/beer_details/beerView.dart';
import 'package:hopmasters/views/notFound/not_found_page.dart';
import 'package:hopmasters/models/brewery.dart';
/*
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => AppView(),
  "/cart": (BuildContext context) => new cartView(name: 'Maracuyipa', count: 3),
};
*/


/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {

        case AppView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AppView(),
          );

        case CartView.routeName:
          final nameArg = args['name'] as String;
          final countArg = args['count'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CartView( name: nameArg, count: countArg ),
          );

        case BreweryView.routeName:

          final breweryArg = args['breweryId'] as int;

          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => BreweryView(breweryId: breweryArg),
          );

        case BeerView.routeName:
          final beerArg = args['beerId'] as int;

          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => BeerView(beerId: beerArg),
          );
        /*
        case CorePage.route:
          final launchId = args['launchId'] as String;
          final coreId = args['coreId'] as String;

          return MaterialPageRoute(
            settings: routeSettings,
            fullscreenDialog: true,
            builder: (_) => CorePage(
              launchId: launchId,
              coreId: coreId,
            ),
          );
        */

        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  /// Method that calles the error screen when neccesary
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => NotFoundPage(),
    );
  }
}
