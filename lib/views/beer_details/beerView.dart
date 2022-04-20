
import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:provider/provider.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/components/async_loader.dart';

import 'package:Hops/views/beer_details/components/beer_header.dart';
import 'package:Hops/views/beer_details/components/beer_body.dart';
import 'package:Hops/components/opinion_floating_action.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/models/login.dart';





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
class _BeerViewState extends State<BeerView> with SingleTickerProviderStateMixin  {

  Future<Beer?>? _beerFuture;
  LoginResponse? _userData;
  bool _activeButton = false;
  bool _hideCommentsFloatingButtons = false;
  Map<String, dynamic> _scores = new Map();


  refresh() {

    if (_hideCommentsFloatingButtons == false){
      setState(() {
        _hideCommentsFloatingButtons = true;
      });
    }else{
      setState(() {
        _hideCommentsFloatingButtons = false;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _beerFuture = getBeer();

    _scores["opinionCount"] = 0;
    _scores["opinionScore"] = 0.0;

    WidgetsBinding.instance?.addPostFrameCallback((_){

      _beerFuture!.then((beerData){

        refreshScore(
            int.parse(beerData!.scoreCount!),
            double.parse(beerData.scoreAvg!)
        );
      });

    });

  }

  Future<Beer?> getBeer() async {
    _userData =  await SharedServices.loginDetails();

    return await WordpressAPI.getBeer(widget.beerId.toString(), userId: _userData!.data!.id.toString());
  }

  refreshScore(int opinionCount, double opinionScore) {
    setState(() {

      _scores["opinionCount"] = opinionCount;
      _scores["opinionScore"] = opinionScore;

    });
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
            case ConnectionState.waiting: return AsyncLoader(text: "Cargando cerveza...",);
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else

                return Scaffold(
                floatingActionButton: (_hideCommentsFloatingButtons == false ? OpinionFloatingAction(
                  "PUBLICAR",
                  "OPINAR",
                  title: "OPINAR",
                  //height: 430,
                  height: MediaQuery.of(context).size.height * 0.5,
                  isActive: _activeButton,
                  bgColor: snapshot.data.rgbColor.withOpacity(0.95),
                  textColor: Colors.white,
                  child: null,
                  userData: _userData,
                  comment: snapshot.data.comment,
                  postId: int.parse(snapshot.data.beerId),
                  updateParentScore: refreshScore,
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
                ) : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FloatingActionButton.extended(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
                      onPressed: (){
                        refresh();
                        Navigator.pop(context);
                      },
                      backgroundColor: snapshot.data.rgbColor.withOpacity(0.95),
                      label: Text("X", style: TextStyle(color: Colors.white, fontSize: 12))
                  ),
                ) ),
                body: new SingleChildScrollView(
                  child: new Container(
                    decoration: linearGradient,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BeerHeader(
                          beer: snapshot.data,
                          userData: _userData,
                          notifyParent: refresh
                        ),
                        SizedBox(height: 10,),
                        BeerBody(beer: snapshot.data, scores: _scores),
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
