import 'package:flutter/material.dart';

class BeerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      color: Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Specification",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF565656))),
          SizedBox(
            height: 15,
          ),
          Column(
            //children: generateProductSpecification(context),
          )
        ],
      ),
    );
  }
}
/*
List<Widget> generateProductSpecification(BuildContext context) {
  List<Widget> list = [];
  int count = 0;
  widget.productDetails.data.productSpecifications.forEach((specification) {
    Widget element = Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(specification.specificationName,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF444444))),
          Text(specification.specificationValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121))),
        ],
      ),
    );
    list.add(element);
    count++;
  });
  return list;
}
*/
