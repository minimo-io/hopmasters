import 'package:Hops/models/login.dart';
import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/theme/style.dart';

import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/beer_details/components/beer_header.dart';
import 'package:Hops/views/beer_details/components/beer_body.dart';
import 'package:Hops/components/opinion_floating_action.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/beer.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          final _formKey = GlobalKey<FormState>();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return AsyncLoader();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else

                return new Scaffold(
                floatingActionButton: OpinionFloatingAction(
                  "PUBLICAR",
                  "OPINAR",
                  //height: 430,
                  height: MediaQuery.of(context).size.height * 0.5,
                  isActive: _activeButton,
                  bgColor: snapshot.data.rgbColor.withOpacity(0.95),
                  textColor: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Contanos qué te pareció esta cerveza y qué puntaje le dejarías.", style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RatingBar.builder(
                            initialRating: 3,
                            glow:true,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            unratedColor: Colors.amber.withAlpha(85),
                            itemCount: 5,
                            itemSize: 40.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                //_rating = rating;
                              });
                            },
                            updateOnDrag: true,
                          ),
                        ),
                        SizedBox(height: 10,),
                        //Text("Un comentario", style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,

                            maxLines: 5,
                            minLines: 1,

                            //style: TextStyle( fontSize: 13 ),

                            decoration: new InputDecoration(
                              labelStyle: TextStyle( color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w300 ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorScheme.primary, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorScheme.primary, width: 1),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: new BorderSide(color: colorScheme.primary)),
                              hintText: 'Contanos...',
                              labelText: '¿Qué te pareció esta cerveza?',
                              helperText: 'Intenta ser amable como te gustan que sean contigo 😊',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  title: "OPINAR",
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
