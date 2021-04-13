import 'package:flutter/material.dart';
import 'package:hopmasters/models/beer.dart';

class BeerBody extends StatelessWidget {

  final beer;
  BeerBody({
    @required Beer this.beer
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Text("Detalles",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF565656))),
          SizedBox(
            height: 15,
          ),
          Column(
            children: generateBeerSpecification(context, beer),
          )
        ],
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
        Text(beer.id.toString(),
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
          Text("Strong Ale",
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
        Text("4%",
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
        Text("500mL",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121))),
      ],
    ),
  );
  list.add(element0);
  list.add(element);
  list.add(element2);
  list.add(element3);
  //});
  return list;
}

