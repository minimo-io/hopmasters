import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/utils/notifications.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/diagonally_cut_colored_image.dart';
import 'package:Hops/utils/load_network_image.dart';
import 'package:Hops/components/followers_info.dart';

import 'package:Hops/components/bottom_sheet.dart';
import 'package:Hops/components/counter_selector.dart';

import 'package:Hops/helpers.dart';


class BeerHeader extends StatefulWidget{


  BeerHeader({
    required Beer? this.beer,
    this.userData
  });

  final beer;
  final LoginResponse? userData;

  @override
  _BeerHeaderState createState() => _BeerHeaderState();
}

class _BeerHeaderState extends State<BeerHeader> with SingleTickerProviderStateMixin {

  late Future<Map<String,dynamic>?> _userBeersPreferences;
  bool _isBeerIncluded = false;
  bool _isLoadingApiCall = false;

  @override
  void initState(){
    _userBeersPreferences = WordpressAPI.getUserPrefs(
        widget.userData?.data?.id,
        indexType: "beers_favorites_preference"
    );

    void defineBeers(BuildContext context)async {
      _userBeersPreferences.then((beers_prefs) {
        String beersFollowed = (beers_prefs!["result"] != null ? beers_prefs["result"] : "" );
        String beerId = (widget.beer?.beerId != null ? widget.beer!.beerId : '');
        bool isBeerIncluded = beersFollowed.contains(beerId);

        setState(() {
          this._isBeerIncluded = isBeerIncluded;
        });
      });
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) => defineBeers(context));

  }

  Widget _buildBeerAvatar(){
    return new Align(
      alignment: FractionalOffset.bottomCenter,
      heightFactor: 1.2,
      child: new Column(
        children: <Widget>[
          Hero(
            tag: "beer-" + widget.beer.name,
            child: LoadNetworkImage(uri: widget.beer.image, height: 230,),
          ),
        ],
      ),
    );
  }

  Widget _buildBeerPrice(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("\$" + this.widget.beer.price,
            style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {

    Widget _buildButton({
      required Text text,
      required Icon icon,
      Function? doOnPressed = null,
      bool isGrey = false
    }){
        return ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: ElevatedButton.icon(
              icon: icon,
              label: text,
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 15, vertical: 7.5)),
                  foregroundColor: MaterialStateProperty.all<Color>((isGrey ? Colors.white70 : Colors.white)),
                  backgroundColor: (
                      isGrey
                      ? MaterialStateProperty.all<Color>(Colors.white24.withOpacity(.5))
                      : MaterialStateProperty.all<Color?>(widget.beer.rgbColor)
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          side: (isGrey ? BorderSide(style: BorderStyle.none) : BorderSide(color: widget.beer.rgbColor))
                      )
                  )
              ),
              onPressed: doOnPressed as void Function()?
          ),
        );

    }



    Widget _unfollowButton(){
      return Padding(
          padding: EdgeInsets.only(right: 2),
          child:_buildButton(
              isGrey: true,
              text: Text("ABANDONAR"),
              icon:  Icon(Icons.close),
              doOnPressed: _unfollowAction
          )
      );
    }
    Widget _followButton(){
      return Padding(
          padding: EdgeInsets.only(right: 2),
          child:_buildButton(
              text: Text("FAVORITA"),
              icon:  Icon(Icons.favorite_border_outlined),
              doOnPressed: _followAction
          )
      );
    }


    return new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // (_isBeerIncluded ? _unfollowButton() : _followButton() ),
          CounterSelector(color: widget.beer.rgbColor),
          Padding(
              padding: EdgeInsets.only(left:2),
              child: _buildButton(text: Text("COMPRAR"), icon: Icon(Icons.shopping_cart), doOnPressed: (){
                //Helpers.showPersistentBottomSheet(context);
              })
          )
        ],
      )
    );
  }

  void _followAction()async{
    HopsNotifications notificationClient =  new HopsNotifications();
    try {
      // get user details


      int? userId = widget.userData?.data?.id;
      int beerId = int.parse(widget.beer!.beerId);
      setState(() => this._isLoadingApiCall = true );
      // api call
      bool favRest = await WordpressAPI.editBeerPref(
          (userId != null ? userId : 0),
          beerId,
          addOrRemove: "add"
      );

      if (favRest == true){
        setState(() => this._isLoadingApiCall = false );
        //setState(() => this._breweryFollowersCount++  );
        setState(() { this._isBeerIncluded = true; });

        notificationClient.message(context, WordpressAPI.MESSAGE_OK_FOLLOWING_BREWERY);

      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(error);
    }
  }
  void _unfollowAction()async{
    HopsNotifications notificationClient =  new HopsNotifications();
    try {
      // get user details


      int? userId = widget.userData?.data?.id;
      int beerId = int.parse(widget.beer!.beerId);
      setState(() => this._isLoadingApiCall = true );
      // api call
      bool favRest = await WordpressAPI.editBeerPref(
          (userId != null ? userId : 0),
          beerId,
          addOrRemove: "remove"
      );

      if (favRest == true){
        setState(() => this._isLoadingApiCall = false );
        //setState(() => this._breweryFollowersCount++  );
        setState(() { this._isBeerIncluded = false; });

        notificationClient.message(context, WordpressAPI.MESSAGE_OK_FOLLOWING_BREWERY);

      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(error);
    }
  }

  Widget _followIconButton(){
    return InkWell(
        onTap: _followAction,
        child: Icon(Icons.favorite_border, color: Colors.white,)
    );
  }

  Widget _unfollowIconButton(){
    return InkWell(
        onTap: _unfollowAction,
        child: Icon(Icons.favorite, color: Colors.white,)
    );
  }

  Widget _buildFavoriteButton(){

    return FutureBuilder(
        future: _userBeersPreferences,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1,);
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {

                if (_isLoadingApiCall == true){
                  return CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1,);
                }
                return (_isBeerIncluded ? _unfollowIconButton() : _followIconButton() );
              }

          }
        }
    );


  }

  @override
  Widget build(BuildContext context) {

    return new Stack(
      children: <Widget>[
        DiagonallyCutColoredImage(
            new Image.asset(
              "assets/images/beer_bg_bw2.png",
              width: MediaQuery.of(context).size.width,
              height: 440,
              fit: BoxFit.cover,
            ),
            //color: colorScheme.background.withOpacity(0.75)
            color: widget.beer.rgbColor.withOpacity(0.35)
        ),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,
          child: new Column(
            children: <Widget>[
              _buildBeerAvatar(),
              _buildBeerPrice(),
              //FollowersInfo(this.beer.followers, textColor: SECONDARY_TEXT_DARK),
              //if (_isLoadingApiCall == true) Padding(padding:EdgeInsets.only(top:16), child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR)) else _buildActionButtons(Theme.of(context), context),
              _buildActionButtons(Theme.of(context), context),
            ],
          ),
        ),

        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),


         new Positioned(
            top: 38.0,
            right: 60.0,
            child: _buildFavoriteButton(),
          ),


        new Positioned(
          top: 38.0,
          right: 20.0,
          child: InkWell(
            onTap: (){
              Share.share('Mirá este cerveza, te puede interesar https://hops.uy/?p=' + widget.beer.beerId ,);
            },
            child: Icon(Icons.share, color: Colors.white,)
          ),
        ),


      ],
    );
  }
}