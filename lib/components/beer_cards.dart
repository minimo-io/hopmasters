import 'package:Hops/utils/progress_hud.dart';
import 'package:flutter/material.dart';

import 'package:Hops/models/beer.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/helpers.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/stars_score.dart';

class BeerCards extends StatefulWidget {
  List? beersList;
  String? loadingText;
  String? userBeersList; // possible favorite beers to call
  String viewType;
  String discoverBeersType;
  String? discoverBeersTypeExtraParam;

  BeerCards(
      {this.beersList,
      this.loadingText,
      this.userBeersList,
      this.viewType = "list",
      this.discoverBeersType = "recent",
      this.discoverBeersTypeExtraParam = "",
      Key? key})
      : super(key: key);

  @override
  _BeerCardsState createState() => _BeerCardsState();
}

class _BeerCardsState extends State<BeerCards> {
  Future? _beers;
  static int _page = 1;
  List<Widget> _moreBeersCardList = <Widget>[];
  bool _isLoadingApiCall = false;
  bool _hideLoadMoreButton = false;

  @override
  void initState() {
    super.initState();

    if (widget.beersList != null) {
      // in this case we already have the beer list, just build a future wait 0
      _page = 1;
      _beers =
          Future.delayed(const Duration(seconds: 1), () => widget.beersList);
    } else {
      // else make the query

      _beers = WordpressAPI.getBeers(
          userBeers: widget.userBeersList!,
          type: widget.discoverBeersType,
          extraParam1: widget.discoverBeersTypeExtraParam);
    }
  }

  /*
  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }
   */

  @override
  Widget build(BuildContext context) {
    Widget _buildBeerGridItem(Beer beer) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/beer",
            arguments: {'beerId': int.parse(beer.beerId)},
          );
        },
        child: SizedBox(
          height: 250,
          width: (MediaQuery.of(context).size.width - 36) / 2,
          child: Card(
            elevation: 4,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(top: 5.0, right: 8),
                      //       child: InkWell(
                      //           onTap: () {
                      //             print("FFFFF");
                      //           },
                      //           child: Icon(Icons.favorite_border,
                      //               color: colorScheme.secondaryVariant
                      //                   .withOpacity(0.5))),
                      //     )),
                      Expanded(
                        child: Image.network(beer.image!, height: 200),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10.0)),

                      Text(
                        beer.name!,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "\$${beer.price}",
                        style: TextStyle(fontSize: 11),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 4),
                      child: Text(
                        'NUEVO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    color: Colors.pinkAccent.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildBeerListItem(Beer beer) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/beer",
            arguments: {'beerId': int.parse(beer.beerId)},
          );
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 0.0, right: 5.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: "beer-" + beer.beerId,
                  child: Image.network(
                    beer.image!,
                    fit: BoxFit.cover, // this is the solution for border
                    //width: 55.0,
                    height: 70.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(beer.name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                              textAlign: TextAlign.left),
                          Row(
                            children: <Widget>[
                              Image.network(
                                beer.breweryImage!,
                                height: 15,
                                fit: BoxFit.fill,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    beer.breweryName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            SECONDARY_TEXT_DARK.withOpacity(1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(beer.type.toString(),
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.left),
                          Text(
                              "ABV: " +
                                  beer.abv.toString() +
                                  ". IBU: " +
                                  beer.ibu.toString(),
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.left),
                        ]),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          StarsScore(
                            opinionCount: int.parse(beer.scoreCount!),
                            opinionScore: double.parse(beer.scoreAvg!),
                            onlyStars: false,
                            starSize: 17.0,
                            textSize: 12.0,
                            textTopPadding: 5.0,
                          )
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10.0),
                      //   child: Text(
                      //       beer.followers.toString() +
                      //           " seguidor" +
                      //           (int.parse(beer.followers!) != 1 ? "es" : ""),
                      //       style:
                      //           TextStyle(fontSize: 14, color: Colors.black54),
                      //       textAlign: TextAlign.left),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildBeerGrid(List<dynamic> beersList) {
      var beersBottom =
          (beersList as List).map((data) => new Beer.fromJson(data)).toList();

      List<Widget> beerCardList = [];

      for (var i = 0; i < beersBottom.length; i++) {
        int nextKey = i + 1;
        if (beersBottom.asMap().containsKey(nextKey)) {
          beerCardList.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildBeerGridItem(beersBottom[i]),
              _buildBeerGridItem(beersBottom[nextKey])
            ],
          ));
          i++;
        } else {
          beerCardList.add(_buildBeerGridItem(beersBottom[i]));
        }
      }

      if (beersBottom.length > 0) {
        // define size
        final double itemHeight = 270;
        final double itemWidth = MediaQuery.of(context).size.width / 2;

        /*
        return GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            childAspectRatio: (itemWidth / itemHeight),

            crossAxisCount: 2,
            children: beerCardList,

        );
        */

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: beerCardList);
      } else {
        return Center(
            child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 8,
            ),
            Text("Ninguna cerveza todavía",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5.0),
            Text("¿Conoces alguna?"),
            SizedBox(height: 5.0),
            RaisedButton.icon(
              label: Text("Ponete en contacto"),
              icon: Icon(Icons.send),
              onPressed: () => Helpers.launchURL("https://hops.uy/contacto/"),
            )
          ]),
        ));
      }
    }

    Widget _buildBeerList(List<dynamic> beersList) {
      var beersBottom = (beersList).map((data) => Beer.fromJson(data)).toList();

      //List<Widget> beerCardList = new List<Widget>();
      List<Widget> beerCardList = <Widget>[];
      for (var i = 0; i < beersBottom.length; i++) {
        beerCardList.add(_buildBeerListItem(beersBottom[i]));
      }

      if (beersBottom.isNotEmpty) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: beerCardList);
      } else {
        return Center(
            child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 8,
            ),
            const Text("Ninguna cerveza todavía",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5.0),
            Text("¿Conoces alguna?"),
            SizedBox(height: 5.0),
            RaisedButton.icon(
              label: Text("Ponete en contacto"),
              icon: Icon(Icons.send),
              onPressed: () => Helpers.launchURL("https://hops.uy/contacto/"),
            )
          ]),
        ));
      }
    }

    Widget _buildLoadMoreButton() {
      return OutlinedButton(
          onPressed: () {
            setState(() {
              _page++;
              _isLoadingApiCall = true;
            });

            WordpressAPI.getBeers(
                    page: _page,
                    type: widget.discoverBeersType,
                    extraParam1: widget.discoverBeersTypeExtraParam)
                .then((beersList) {
              setState(() => _isLoadingApiCall = false);
              var beersBottom = (beersList as List)
                  .map((data) => new Beer.fromJson(data))
                  .toList();
              setState(() {
                if (beersBottom.length < 10)
                  setState(() => _hideLoadMoreButton = true);
                for (var beerItem in beersBottom) {
                  _moreBeersCardList.add(_buildBeerListItem(beerItem));
                }
              });
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.black54,
              ),
              SizedBox(
                width: 5,
              ),
              Text("CARGAR MAS", style: TextStyle(color: Colors.black54))
            ],
          ));
    }

    return Container(
      color: Colors.transparent,
      //height: MediaQuery.of(context).size.height * 0.60,
      //height: 270 * 2,
      //constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: double.infinity, maxHeight: double.infinity),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: marginSide),
        child: FutureBuilder(
            future: _beers,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Center(
                          //child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,)
                          child: Image.asset(
                        "assets/images/loader-hops.gif",
                        width: 100,
                      )),
                      if (widget.loadingText != null)
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(widget.loadingText!)),
                      SizedBox(height: 10),
                    ],
                  ));
                default:
                  // print("LEN: " + snapshot.data.length.toString());
                  return Column(
                    children: [
                      Container(
                          child: (widget.viewType == "grid"
                              ? _buildBeerGrid(snapshot.data)
                              : _buildBeerList(snapshot.data))),
                      if (widget.userBeersList == null &&
                          snapshot.data.length >= 10)
                        Column(
                          children: _moreBeersCardList,
                        ),
                      if (widget.userBeersList == null &&
                          snapshot.data.length >= 10)
                        (_isLoadingApiCall
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Center(
                                        //child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,)
                                        child: Image.asset(
                                      "assets/images/loader-hops.gif",
                                      width: 100,
                                    )),
                                    const Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text("Cargando cervezas..."),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )),
                              )
                            : (_hideLoadMoreButton == true
                                ? Container()
                                : _buildLoadMoreButton()))
                    ],
                  );
              }
            }),
      ),
    );
  }
}
