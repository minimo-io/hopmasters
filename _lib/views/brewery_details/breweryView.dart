import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:Hops/models/login.dart';
import 'package:Hops/models/brewery.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/opinion_floating_action.dart';

import 'package:Hops/views/brewery_details/components/footer/brewery_showcase.dart';
import 'package:Hops/views/brewery_details/components/brewery_detail_body.dart';
import 'package:Hops/views/brewery_details/components/header/brewery_detail_header.dart';


class BreweryView extends StatefulWidget {
  static const routeName = "/brewery";

  final Object? breweryId;

  BreweryView({ this.breweryId });

  @override
  _BreweryViewState createState() => new _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {
  Future<Brewery?>? _breweryFuture;
  bool _activeButton = false;
  LoginResponse? _userData;
  Map<String, dynamic> _scores = new Map();


  @override
  void initState(){
    super.initState();
    _breweryFuture = getBrewery();

    _scores["opinionCount"] = 0;
    _scores["opinionScore"] = 0.0;

    WidgetsBinding.instance?.addPostFrameCallback((_){
      _breweryFuture!.then((breweryData){
        refreshScore(
            int.parse(breweryData!.scoreCount!),
            double.parse(breweryData.scoreAvg!)
        );
      });

    });
  }

  refreshScore(int opinionCount, double opinionScore) {
    setState(() {

      _scores["opinionCount"] = opinionCount;
      _scores["opinionScore"] = opinionScore;

    });
  }

  Future<Brewery?> getBrewery() async {
    _userData =  await SharedServices.loginDetails();
    //return await WordpressAPI.getBrewery(widget.breweryId.toString(), userId: _userData!.data!.id.toString());
    return await WordpressAPI.getBrewery(widget.breweryId.toString(), userId: _userData!.data!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: PRIMARY_GRADIENT_COLOR,
    );

    return FutureBuilder(
      future: _breweryFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return AsyncLoader( text: "Cargando cervecería...", );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else

              return Scaffold(
                floatingActionButton: OpinionFloatingAction(
                    "PUBLICAR",
                    "OPINAR",
                    title: "OPINAR",
                    commentText: "Contanos qué te parece esta cervecería y qué puntaje le dejarías.",
                    height: MediaQuery.of(context).size.height * 0.5,
                    isActive: _activeButton,
                    child: null,
                    userData: _userData,
                    comment: snapshot.data.comment,
                    bgColor: snapshot.data.rgbColor.withOpacity(0.95),
                    textColor: Colors.white,
                    postId: int.parse(snapshot.data.id),
                    onTap: (){

                      setState(() {
                        if (_activeButton == true ){
                          //_activeButton = false;


                        }else{
                          _activeButton = true;
                        }
                      });

                    },
                    onClose: (){
                      setState(() {
                        if (_activeButton == true ){
                          _activeButton = false;
                        }else{
                          _activeButton = true;
                        }
                      });
                    }
                ),
                body: new SingleChildScrollView(
                  child: new Container(
                    decoration: linearGradient,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new BreweryDetailHeader(
                            snapshot.data,
                            avatarTag: "brewery-" +
                                widget.breweryId.toString(),
                            userData: _userData,
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: new BreweryDetailBody(
                              snapshot.data,
                              scores: _scores
                          ),
                        ),
                        new BreweryShowcase(snapshot.data),
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
