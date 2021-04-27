import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:hopmasters/models/brewery.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/helpers.dart';

class BreweryBeers extends StatefulWidget {
  Brewery brewery;

  BreweryBeers({ this.brewery });

  @override
  _BreweryBeersState createState() => _BreweryBeersState();
}

class _BreweryBeersState extends State<BreweryBeers> {
  Future _breweryBeers;

  @override
  void initState() {
    super.initState();
    //_breweryBeers = _getBeersFromBreweryID();
    _breweryBeers = Helpers.getBeersFromBreweryID(widget.brewery.id);

    print(_breweryBeers);
  }

  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 1; i <= 6; i++) {
      var image = new Image.asset(
        'assets/images/portfolio_$i.jpeg',
        width: 200.0,
        height: 200.0,
      );

      items.add(image);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return new GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: _buildItems(),
    );
  }
}
