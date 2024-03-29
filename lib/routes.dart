import 'package:Hops/views/order_details/order_details.dart';
import 'package:Hops/views/order_results/order_results.dart';
import 'package:Hops/views/scores/scoresView.dart';
import 'package:flutter/material.dart';

import 'package:Hops/views/login/loginView.dart';
import 'package:Hops/views/preferences_signup/preferencesSignup.dart';
import 'package:Hops/views/appView.dart';
import 'package:Hops/views/cart/cartView.dart';
import 'package:Hops/views/brewery_details/breweryView.dart';
import 'package:Hops/views/beer_details/beerView.dart';
import 'package:Hops/views/comments/commentsView.dart';
import 'package:Hops/views/checkout/checkoutView.dart';
import 'package:Hops/views/shipping_details/shippingDetails.dart';
import 'package:Hops/views/orders/ordersView.dart';
import 'package:Hops/views/experiences/experiencesView.dart';
import 'package:Hops/views/payments/paymentsView.dart';
import 'package:Hops/views/notFound/not_found_page.dart';

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
      final Map<String, dynamic>? args =
          routeSettings.arguments as Map<String, dynamic>?;

      switch (routeSettings.name) {
        case AppView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AppView(),
          );

        case LoginView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LoginView(),
          );

        case PreferencesSignUpView.routeName:
          final fromMain = args?['fromMainApp'] as bool;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PreferencesSignUpView(
              fromMainApp: fromMain,
            ),
          );

        case CartView.routeName:
          // final nameArg = args!['name'] as String?;
          // final countArg = args['count'] as int?;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CartView(),
          );
        case PaymentsView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PaymentsView(),
          );
        case OrderDetailsView.routeName:
          final orderId = args!['orderId'] as int;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrderDetailsView(
              orderId: orderId,
            ),
          );
        case OrderResultsView.routeName:
          final results = args!['results'] as String;
          final payment = args['payment'] as String;
          final amount = args['amount'] as double;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrderResultsView(
                results: results, payment: payment, amount: amount),
          );
        case CheckoutView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CheckoutView(),
          );

        case ExperiencesView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ExperiencesView(),
          );

        case ScoresView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ScoresView(),
          );

        case ShippingDetails.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ShippingDetails(),
          );

        case OrdersView.routeName:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => OrdersView(),
          );

        case BreweryView.routeName:
          final breweryArg = args!['breweryId'] as int?;

          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => BreweryView(breweryId: breweryArg),
          );

        case CommentsView.routeName:
          final postId = args!['postId'] as int?;
          final postTitle = args['postTitle'] as String?;

          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CommentsView(
              postId: (postId != null ? postId : 0),
              postTitle: postTitle,
            ),
          );

        case BeerView.routeName:
          final beerArg = args!['beerId'] as int?;

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
