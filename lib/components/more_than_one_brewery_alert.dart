import 'package:Hops/models/cart.dart';
import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';

class MoreThanOneBreweryAlert extends StatelessWidget {
  Cart cart;
  EdgeInsets internalPadding;
  EdgeInsets padding;
  double cardElevation;
  MoreThanOneBreweryAlert(this.cart,
      {this.internalPadding =
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      this.padding = EdgeInsets.zero,
      this.cardElevation = cardsElevations,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int breweriesCount = cart.getBreweriesFromCart().length;

    if (breweriesCount > 1) {
      return Padding(
        padding: padding,
        child: Card(
          elevation: cardElevation,
          child: Padding(
            padding: internalPadding,
            child: Row(
              children: const [
                Icon(
                  Icons.warning,
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                    child: Text(
                        "Recuerda que estas comprando directamente a las cervecerías. Por lo tanto cada pedido se procesará por separado.",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.normal)))
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
