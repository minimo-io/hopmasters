import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/theme/style.dart';

import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/beer_details/components/beer_header.dart';
import 'package:Hops/views/beer_details/components/beer_body.dart';
import 'package:Hops/components/opinion_floating_action.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/models/beer.dart';

class BeerView extends StatefulWidget {
  static const routeName = "/beer";
  final Object? beerId;

  BeerView({ this.beerId });


  @override
  _BeerViewState createState() => _BeerViewState();
}
class MyFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (context) => Container(
              color: Colors.red,
            ));
      },
    );
  }
}
class _BeerViewState extends State<BeerView> with AutomaticKeepAliveClientMixin<BeerView> {

  Future<Beer?>? _beerFuture;
  LoginResponse? _userData;
  bool _activeButton = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //_beerFuture = WordpressAPI.getBeer(widget.beerId.toString());
    _beerFuture = getBeer();
  }

  Future<Beer?> getBeer() async {
    _userData =  await SharedServices.loginDetails();
    return await WordpressAPI.getBeer(widget.beerId.toString());
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
                floatingActionButton: OpinionFloatingAction(
                  _activeButton ?  "PUBLICAR" : "OPINAR",
                  bgColor: snapshot.data.rgbColor.withOpacity(0.95),
                  textColor: Colors.white,
                  child: Container(
                    child: Text("Formulario")
                  ),
                  title: "OPINAR",
                  onTap: (){
                      print("OOOK");
                      setState(() {
                        _activeButton = true;
                      });
                  },
                ),
                body: new SingleChildScrollView(
                  child: new Container(
                    decoration: linearGradient,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BeerHeader(
                          beer: snapshot.data,
                          userData: _userData,
                        ),
                        SizedBox(height: 10,),
                        BeerBody(beer: snapshot.data),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ),
              );;
          }


        }
    );



  }



}
