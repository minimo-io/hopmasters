import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';

class HopsAlert extends StatelessWidget {
  final EdgeInsets internalPadding;
  final EdgeInsets padding;
  final double cardElevation;
  final String text;
  final IconData icon;
  final Color color;

  const HopsAlert(
      {this.internalPadding =
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      this.padding = EdgeInsets.zero,
      this.cardElevation = cardsElevations,
      required this.text,
      required this.icon,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        elevation: cardElevation,
        child: Padding(
          padding: internalPadding,
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                  child: Text(text,
                      style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.normal)))
            ],
          ),
        ),
      ),
    );
  }
}
