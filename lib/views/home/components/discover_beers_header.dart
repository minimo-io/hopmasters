import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';


class DiscoverBeersHeader extends StatefulWidget {

  DiscoverBeersHeader({ Key key }) : super(key: key);

  @override
  _DiscoverBeersHeaderState createState() => _DiscoverBeersHeaderState();
}


class _DiscoverBeersHeaderState extends State<DiscoverBeersHeader> {
  // _DiscoverBeersHeaderState(this._appBarTitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(marginSide),
      child: Padding(
        /*padding: const EdgeInsets.only(top: 8.0),*/
        padding:const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Descubrir',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: beerStyles.length,
                itemBuilder: (_, index) => Padding(
                  padding: index == 0
                      ? const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4)
                      : const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4),
                  child: Text(
                    beerStyles[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: index == 0 ? colorScheme.secondary : colorScheme.secondary.withOpacity(0.5)  ,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}