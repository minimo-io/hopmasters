import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/theme/style.dart';

import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/beer_details/components/beer_header.dart';
import 'package:Hops/views/beer_details/components/beer_body.dart';


class BeerView extends StatefulWidget {
  static const routeName = "/beer";
  final Object? beerId;

  BeerView({ this.beerId });


  @override
  _BeerViewState createState() => _BeerViewState();
}

class _BeerViewState extends State<BeerView> {

  Future? _beerFuture;

  @override
  void initState() {
    super.initState();
    _beerFuture = WordpressAPI.getBeer(widget.beerId.toString());
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
        future: _beerFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return AsyncLoader();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return new Scaffold(
                  body: new SingleChildScrollView(
                    child: new Container(
                      decoration: linearGradient,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          BeerHeader(beer: snapshot.data),
                          SizedBox(height: 10,),
                          BeerBody(beer: snapshot.data),
                          SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ),
                );
          }


        }
    );



  }



}
