import 'package:flutter/material.dart';

import 'package:Hops/models/brewery.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/views/brewery_details/components/footer/articles_showcase.dart';
import 'package:Hops/views/brewery_details/components/footer/brewery_beers.dart';
import 'package:Hops/views/brewery_details/components/footer/skills_showcase.dart';

class BreweryShowcase extends StatefulWidget {
  BreweryShowcase(this.brewery);

  final Brewery brewery;

  @override
  _BreweryShowcaseState createState() => new _BreweryShowcaseState();
}

class _BreweryShowcaseState extends State<BreweryShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Cervezas'),
      new Tab(text: 'Brewers'),
      new Tab(text: 'Estilos'),
    ];
    _pages = [
      new BreweryBeers(brewery: widget.brewery),
      new SkillsShowcase(),
      new ArticlesShowcase(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: SECONDARY_TEXT_DARK,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
