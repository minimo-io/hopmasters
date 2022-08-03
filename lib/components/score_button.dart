import 'package:Hops/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class ScoreButton extends StatelessWidget {
  const ScoreButton({
    Key? key,
    required this.text,
    required this.image,
    this.press,
    required this.score,
    this.contrast = "low",
    this.showDetailsButton = true,
    this.cardPadding = const EdgeInsets.symmetric(horizontal: 20.0),
  }) : super(key: key);

  final String text;
  final Image image;
  final VoidCallback? press;
  final String contrast;
  final int score;
  final bool showDetailsButton;
  final EdgeInsets cardPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: cardPadding,
      child: Card(
        elevation: cardsElevations,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image,
                    const SizedBox(width: 5.0),
                    Expanded(
                        child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 12,
                          color: (this.contrast == "high"
                              ? Colors.white
                              : Colors.black)),
                    )),
                    if (showDetailsButton)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "scores");
                        },
                        child: Badge(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          toAnimate: false,
                          shape: BadgeShape.square,
                          borderRadius: BorderRadius.circular(20.0),
                          badgeColor: Colors.grey.withOpacity(.8),
                          badgeContent: Row(
                            children: [
                              Text(
                                'Detalles',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.8),
                                    fontSize: titlesRightButtonsSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
    //   child: FlatButton(
    //     padding: const EdgeInsets.all(10),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //     //color: Color(0xFFF5F6F9),
    //     color: (this.contrast == "high" ? Colors.black : Color(0xFFF5F6F9)),
    //     onPressed: press,
    //     child: Row(
    //       children: [
    //         image,
    //         const SizedBox(width: 20),
    //         Expanded(
    //             child: Text(
    //           text,
    //           style: TextStyle(
    //               color:
    //                   (this.contrast == "high" ? Colors.white : Colors.black)),
    //         )),
    //       ],
    //     ),
    //   ),
    // );
  }
}
