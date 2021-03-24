import 'package:flutter/material.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';


// The almighty beer class
class Beer{
  final String name, type, image;
  final num abv, price;

  const Beer({this.name, this.type, this.image, this.abv, this.price});
}


class BeerGridTile extends StatelessWidget {
  final String name, image, type;
  final num price;

  const BeerGridTile({this.name, this.image, this.type, this.price});


  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GestureDetector(
    onTap: () {},
    child: GridTileBar(
      backgroundColor: Colors.transparent,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(this.name),
      ),
      subtitle: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(this.type),
      ),
      trailing: Row(
        children: [
          Text(
              '\$' + this.price.toString(),
              style: TextStyle(color: colorScheme.background, fontSize: 16.0)
          )
        ],
      ),
    ),
      ),
      child: Image.asset(
    this.image,
    fit: BoxFit.cover,
      ),
    );
  }
}