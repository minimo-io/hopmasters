import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

class AppTitle extends StatelessWidget {
  final Text title;

  AppTitle({ this.title });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.symmetric( horizontal: 33.0 ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cervecerías',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: (30)),
          ]

        )
    );
  }
}
