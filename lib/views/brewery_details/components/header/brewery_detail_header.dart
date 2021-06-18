import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:share_plus/share_plus.dart';

import 'package:Hops/models/login.dart';
import 'package:Hops/models/preferences.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/utils/notifications.dart';

// import 'package:Hops/theme/style.dart';
import 'package:Hops/components/async_loader.dart';
import 'package:Hops/components/diagonally_cut_colored_image.dart';


import 'package:Hops/models/brewery.dart';



class BreweryDetailHeader extends StatefulWidget {
  static const BACKGROUND_IMAGE = 'assets/images/beer-toast-bg-2.png';

  BreweryDetailHeader(
    this.brewery, {
    required this.avatarTag,
    this.userData,
  });

  final Brewery? brewery;
  final Object avatarTag;
  final LoginResponse? userData;

  @override
  _BreweryDetailHeaderState createState() => _BreweryDetailHeaderState();
}

class _BreweryDetailHeaderState extends State<BreweryDetailHeader> with SingleTickerProviderStateMixin{
  bool _isLoadingApiCall = false;
  bool _isBreweryIncluded = false;
  int _breweryFollowersCount = -1;


  late AnimationController _animationController;
  late Future<Map<String,dynamic>?> _userBreweriesPreferences;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _userBreweriesPreferences = WordpressAPI.getUserPrefs(
        widget.userData?.data?.id,
        indexType: "breweries_preferences"
    );
    this._breweryFollowersCount = int.parse(widget.brewery!.followers!);
    // after layour is built then set the state that will define
    // which button to show: follow or unfollow.
    defineBreweries(BuildContext context)async{

      _userBreweriesPreferences.then((breweries_prefs){


        String breweriesFollowed = breweries_prefs!["result"];
        String breweryId = (widget.brewery?.id != null ? widget.brewery!.id : '' );
        bool isBreweryIncluded = breweriesFollowed.contains(breweryId);


        setState(() {
          this._isBreweryIncluded = isBreweryIncluded;
        });




      });

    }
    WidgetsBinding.instance?.addPostFrameCallback((_) => defineBreweries(context));


  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BreweryDetailHeader.BACKGROUND_IMAGE,
        width: screenWidth,
        height: 335.0,
        fit: BoxFit.cover,
      ),
      color: widget.brewery!.rgbColor.withOpacity(0.3)
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: widget.avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(widget.brewery!.avatar!),
        //backgroundImage: LoadNetworkImage(brewery.avatar),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(_breweryFollowersCount.toString() + ' seguidores', style: TextStyle(color: Color(0xBBFFFFFF), fontSize: 18, fontWeight: FontWeight.bold), ),
        ],
      ),
    );
  }

  Widget _followButton(){
    return ClipRRect(
      borderRadius: new BorderRadius.circular(10.0),
      child: ElevatedButton.icon(
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animationController,
          ),
          label: Text(
              "SEGUIR",
              style: TextStyle(fontSize: 14)
          ),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
              backgroundColor: MaterialStateProperty.all<Color>(widget.brewery!.rgbColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: widget.brewery!.rgbColor)
                  )
              )
          ),
          onPressed: _followAction
      ),
    );
  }

  Widget _unfollowButton(){
    return ClipRRect(
      borderRadius: new BorderRadius.circular(10.0),
      child: ElevatedButton.icon(
          icon: Icon(Icons.close),
          label: Text(
              "DEJAR DE SEGUIR",
              style: TextStyle(fontSize: 14)
          ),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white24.withOpacity(.5)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(style: BorderStyle.none)
                  )
              )
          ),
          onPressed: _followAction
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    //setState(() { this._isBreweryIncluded = false; });
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (_isLoadingApiCall == true) CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR)
          else (_isBreweryIncluded ? _unfollowButton() : _followButton() )
        ],
      ),
    );
  }

  void _followAction()async{
    HopsNotifications notificationClient =  new HopsNotifications();

    try {
      // get user details


      int? userId = widget.userData?.data?.id;
      int breweryId = int.parse(widget.brewery!.id);
      setState(() => this._isLoadingApiCall = true );
      // api call
      bool favRest = await WordpressAPI.editBreweryPref(
          (userId != null ? userId : 0),
          breweryId,
          addOrRemove: "add"
      );

      if (favRest == true){
        setState(() => this._isLoadingApiCall = false );
        setState(() => this._breweryFollowersCount++  );
        setState(() { this._isBreweryIncluded = true; });

        setState(() {

        });
        // save Shared Service for each preference

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
      int breweryId = int.parse(widget.brewery!.id);
      setState(() => this._isLoadingApiCall = true );
      // api call
      bool favRest = await WordpressAPI.editBreweryPref(
          (userId != null ? userId : 0),
          breweryId,
          addOrRemove: "remove"
      );

      if (favRest == true){
        setState(() => this._isLoadingApiCall = false );
        setState(() => this._breweryFollowersCount--  );
        setState(() { this._isBreweryIncluded = false; });
        // save Shared Service for each preference

        notificationClient.message(context, WordpressAPI.MESSAGE_OK_UNFOLLOWING_BREWERY);

      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_UNFOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false );

      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_UNFOLLOWING_BREWERY);
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
        future: _userBreweriesPreferences,
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
                return (_isBreweryIncluded ? _unfollowIconButton() : _followIconButton() );
              }

          }
        }
    );


  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              SizedBox(height: 35,),
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              /*
              FutureBuilder(
                future: _userBreweriesPreferences,
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {

                        // defineIsSelected(snapshot.data).then((value) {
                          return _buildActionButtons(theme);
                        //});
                        //return
                      }

                  }
                }),
              */
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
                Share.share('Esta cervecería te puede interesar https://hops.uy/?p=' + widget.brewery!.id ,);
              },
              child: Icon(Icons.share, color: Colors.white,)
          ),
        ),


      ],
    );
  }
}
