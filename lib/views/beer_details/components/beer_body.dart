import 'package:flutter/material.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/models/beer.dart';

import 'package:hopmasters/components/followers_info.dart';

class BeerBody extends StatelessWidget {

  final beer;
  BeerBody({
    @required Beer this.beer
  });

  Widget _buildBeerBrewery(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network( beer.breweryImage,
          height: 50,
          fit: BoxFit.fill,
          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ),
        SizedBox(width: 8,),
        Text(beer.breweryName, style: TextStyle(fontSize: 18),)
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {

    Widget _buildButton({Text text, Icon icon}){

      return ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: ElevatedButton.icon(
            icon: icon,
            label: text,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                backgroundColor: MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: SECONDARY_BUTTON_COLOR)
                    )
                )
            ),
            onPressed: () => null
        ),
      );


    }

    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 2),
              child:_buildButton(text:Text("SEGUIR"),icon: Icon(Icons.favorite_border_outlined))
          ),
          Padding(
              padding: EdgeInsets.only(left:2),
              child: _buildButton(text: Text("COMPRAR"), icon: Icon(Icons.shopping_cart))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBeerBrewery(),
          FollowersInfo(this.beer.followers, textColor: SECONDARY_TEXT_DARK),
          _buildActionButtons(Theme.of(context)),
          SizedBox(height: 55,),
          Text("Detalles",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF565656))),
          SizedBox( height: 15 ),
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

