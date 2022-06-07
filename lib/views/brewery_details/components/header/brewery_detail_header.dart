import 'package:Hops/components/hops_button.dart';
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
import 'package:Hops/helpers.dart';

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

class _BreweryDetailHeaderState extends State<BreweryDetailHeader>
    with SingleTickerProviderStateMixin {
  bool _isLoadingApiCall = false;
  bool _isBreweryIncluded = false;
  int _breweryFollowersCount = -1;

  final double _sizeLoadingButton = 30.0;

  late AnimationController _animationController;
  late Future<Map<String, dynamic>?> _userBreweriesPreferences;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _userBreweriesPreferences = WordpressAPI.getUserPrefs(
        widget.userData?.data?.id,
        indexType: "breweries_preferences");
    this._breweryFollowersCount = int.parse(widget.brewery!.followers!);
    // after layour is built then set the state that will define
    // which button to show: follow or unfollow.
    defineBreweries(BuildContext context) async {
      _userBreweriesPreferences.then((breweries_prefs) {
        String breweriesFollowed = breweries_prefs!["result"];
        String breweryId =
            (widget.brewery?.id != null ? widget.brewery!.id : '');
        bool isBreweryIncluded = breweriesFollowed.contains(breweryId);

        setState(() {
          this._isBreweryIncluded = isBreweryIncluded;
        });
      });
    }

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => defineBreweries(context));
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
        color: widget.brewery!.rgbColor.withOpacity(0.3));
  }

  Widget _buildAvatar() {
    return Hero(
      tag: widget.avatarTag,
      child: Stack(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.brewery!.image!),
          //backgroundImage: LoadNetworkImage(brewery.avatar),
          radius: 50.0,
        ),
        Positioned(
          top: 5,
          right: 1,
          width: 20,
          height: 20,
          child: Image.asset("assets/images/flags/uy.png"),
        ),
      ]),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _breweryFollowersCount.toString() +
                ' seguidor' +
                (_breweryFollowersCount > 1 ? "es" : ""),
            style: const TextStyle(
                color: Color(0xBBFFFFFF),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _followButton({Color bgColor = Colors.black}) {
    return HopsButton(
      text: const Text(
        "SEGUIR",
        style: TextStyle(fontSize: 12.0),
      ),
      icon: const Icon(
        Icons.favorite_border,
        size: 12.0,
      ),
      doOnPressed: _followAction,
      bgColor: bgColor,
    );
  }

  Widget _unfollowButton({Color bgColor = Colors.black}) {
    return HopsButton(
      text: const Text(
        "DEJAR DE SEGUIR",
        style: TextStyle(fontSize: 12.0),
      ),
      icon: const Icon(Icons.close, size: 12.0),
      doOnPressed: _unfollowAction,
      bgColor: bgColor,
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    //setState(() { this._isBreweryIncluded = false; });
    return Padding(
      padding: const EdgeInsets.only(
        top: 3.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (_isLoadingApiCall == true)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: _sizeLoadingButton,
                width: _sizeLoadingButton,
                child: const CircularProgressIndicator(
                  color: PROGRESS_INDICATOR_COLOR,
                  strokeWidth: 1.0,
                ),
              ),
            )
          else
            (_isBreweryIncluded
                ? _unfollowButton(bgColor: widget.brewery!.rgbColor)
                : _followButton(bgColor: widget.brewery!.rgbColor))
        ],
      ),
    );
  }

  void _followAction() async {
    HopsNotifications notificationClient = HopsNotifications();

    try {
      // get user details

      int? userId = widget.userData?.data?.id;
      int breweryId = int.parse(widget.brewery!.id);
      setState(() => this._isLoadingApiCall = true);
      // api call
      bool favRest = await WordpressAPI.editBreweryPref(
          (userId != null ? userId : 0), breweryId,
          addOrRemove: "add");

      if (favRest == true) {
        setState(() => this._isLoadingApiCall = false);
        setState(() => this._breweryFollowersCount++);
        setState(() {
          this._isBreweryIncluded = true;
        });

        setState(() {});
        // save Shared Service for each preference

        notificationClient.message(
            context, WordpressAPI.MESSAGE_OK_FOLLOWING_BREWERY);
      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_FOLLOWING_BREWERY);
      print(error);
    }
  }

  void _unfollowAction() async {
    HopsNotifications notificationClient = HopsNotifications();

    try {
      // get user details

      int? userId = widget.userData?.data?.id;
      int breweryId = int.parse(widget.brewery!.id);
      setState(() => this._isLoadingApiCall = true);
      // api call
      bool favRest = await WordpressAPI.editBreweryPref(
          (userId != null ? userId : 0), breweryId,
          addOrRemove: "remove");

      if (favRest == true) {
        setState(() => this._isLoadingApiCall = false);
        setState(() => this._breweryFollowersCount--);
        setState(() {
          this._isBreweryIncluded = false;
        });
        // save Shared Service for each preference

        notificationClient.message(
            context, WordpressAPI.MESSAGE_OK_UNFOLLOWING_BREWERY);
      }
    } on Exception catch (exception) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_UNFOLLOWING_BREWERY);
      print(exception);
    } catch (error) {
      setState(() => this._isLoadingApiCall = false);

      notificationClient.message(
          context, WordpressAPI.MESSAGE_ERROR_UNFOLLOWING_BREWERY);
      print(error);
    }
  }

  Widget _followIconButton() {
    return InkWell(
        onTap: _followAction,
        child: Icon(
          Icons.favorite_border,
          color: Colors.white,
        ));
  }

  Widget _unfollowIconButton() {
    return InkWell(
        onTap: _unfollowAction,
        child: Icon(
          Icons.favorite,
          color: Colors.white,
        ));
  }

  Widget _buildFavoriteButton() {
    return FutureBuilder(
        future: _userBreweriesPreferences,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: PROGRESS_INDICATOR_COLOR,
                    strokeWidth: 1,
                  ));
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (_isLoadingApiCall == true) {
                  return SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: PROGRESS_INDICATOR_COLOR,
                        strokeWidth: 1,
                      ));
                }
                return (_isBreweryIncluded
                    ? _unfollowIconButton()
                    : _followIconButton());
              }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    double safePadding = Helpers.getTopSafeArea(context);

    return Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 1,
              ),
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              // follow button
              FutureBuilder(
                  future: _userBreweriesPreferences,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: _sizeLoadingButton,
                            width: _sizeLoadingButton,
                            child: const CircularProgressIndicator(
                              color: PROGRESS_INDICATOR_COLOR,
                              strokeWidth: 1.0,
                            ),
                          ),
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
            ],
          ),
        ),
        Positioned(
          top: 15.0 + safePadding,
          left: 4.0,
          child: const BackButton(color: Colors.white),
        ),
        // Positioned(
        //   top: 28.0 + safePadding,
        //   right: 60.0,
        //   child: _buildFavoriteButton(),
        // ),
        Positioned(
          top: 28.0 + safePadding,
          right: 20.0,
          child: InkWell(
              onTap: () {
                Share.share(
                  'Esta cervecería te puede interesar https://hops.uy/?p=' +
                      widget.brewery!.id,
                );
              },
              child: const Icon(
                Icons.share,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
