import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';

import 'package:hopmasters/models/brewery.dart';

import 'package:hopmasters/views/brewery_detail/components/footer/brewery_detail_footer.dart';
import 'package:hopmasters/views/brewery_detail/components/brewery_detail_body.dart';
import 'package:hopmasters/views/brewery_detail/components/header/brewery_detail_header.dart';


class BreweryView extends StatefulWidget {
  static const routeName = "/brewery";

  final Brewery brewery;
  final Object avatarTag;

  BreweryView({ this.brewery, this.avatarTag });



  @override
  _BreweryViewState createState() => new _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new BreweryDetailHeader(
                widget.brewery,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new BreweryDetailBody(widget.brewery),
              ),
              new BreweryShowcase(widget.brewery),
            ],
          ),
        ),
      ),
    );
  }
}
