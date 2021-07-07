import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/components/beer_cards.dart';
import 'package:Hops/views/home/components/bannerBreweries.dart';
import 'package:Hops/views/home/components/specialOffers.dart';


class Body extends StatelessWidget {
  Body({
    Key? key,
    this.count,
    this.name
  }) : super(key: key);

  final int? count;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(child: Text('Este es un carrito y tiene ' + count.toString() + ' ' + name!)),
              SizedBox(height: MediaQuery.of(context).size.height,),
            ],
          ),
        ),
      ),
    );
  }
}