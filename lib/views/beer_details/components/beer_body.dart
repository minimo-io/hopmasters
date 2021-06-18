import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/utils/load_network_image.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/text_expandable.dart';

class BeerBody extends StatelessWidget {

  final beer;

  BeerBody({
    required Beer? this.beer
  });

  bool isExpanded = false;

  Widget _buildBreweryInfo(TextTheme textTheme, BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context,
          "/brewery",
          arguments: { 'breweryId': int.parse(this.beer.breweryId) },

        );
      },
      child: new Row(
        children: <Widget>[
          LoadNetworkImage(uri:this.beer.breweryImage, height:15),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              this.beer.breweryName,
              style: TextStyle(color: SECONDARY_TEXT_DARK.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Padding(
      padding: const EdgeInsets.all(25.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                new Text(
                  this.beer.name,
                  style: TextStyle(color:SECONDARY_TEXT_DARK, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: _buildBreweryInfo(textTheme, context),
                ),
              ],),

              StarsScore()


            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: TextExpandable(
                this.beer.description
            ),
          ),
          SizedBox(height: 30,),
          Text("Detalles",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF565656))),
          SizedBox( height: 15 ),
          Column(
            children: generateBeerSpecification(context, this.beer),
          )
        ]
      ),
    );
  }
}

List<Widget> generateBeerSpecification(BuildContext context, Beer beer) {
  List<Widget> list = [];
  int count = 0;
  //widget.productDetails.data.productSpecifications.forEach((specification) {
  Widget element0 = Container(
    height: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("#",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444))),
        Text(beer.beerId.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
    Widget element = Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Estilo",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF444444))),
          Text(beer.type!,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121))),
        ],
      ),
    );
  Widget elementIBU = Container(
    height: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("IBU",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444))),
        Text(beer.ibu!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
  Widget element2 = Container(
    height: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("ABV",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444))),
        Text(beer.abv!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
  // launch
  Widget elementLaunch = Container(
    height: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Lanzamiento",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444))),
        Text(beer.launch!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
  Widget element3 = Container(
    height: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Envase",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444))),
        Text(beer.size!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
  list.add(element0);
  if (beer.launch != "") list.add(elementLaunch);
  list.add(element);
  list.add(elementIBU);
  list.add(element2);
  list.add(element3);
  //});
  return list;
}

