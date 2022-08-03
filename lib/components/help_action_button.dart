import 'package:Hops/helpers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class HelpActionButton extends StatelessWidget {
  final EdgeInsets padding;
  const HelpActionButton(
      {this.padding =
          const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () => Helpers.userAskedForHelp(),
        child: Badge(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          toAnimate: false,
          shape: BadgeShape.square,
          borderRadius: BorderRadius.circular(20.0),
          badgeColor: const Color.fromRGBO(77, 159, 0, .7),
          badgeContent: Row(
            children: [
              Icon(
                Icons.help,
                size: 15.0,
                color: Colors.white.withOpacity(.8),
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                'Ayuda',
                style: TextStyle(
                    color: Colors.white.withOpacity(.8), fontSize: 11.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
