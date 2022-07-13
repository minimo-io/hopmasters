import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class CardHorizontal extends StatefulWidget {
  String text = "";
  VoidCallback? onTap;
  Icon? icon;
  bool useChevron;
  double padding;
  double elevation;
  CardHorizontal(
      {required this.text,
      this.icon,
      this.useChevron = false,
      this.elevation = 0.5,
      this.padding = 15.0,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  State<CardHorizontal> createState() => _CardHorizontalState();
}

class _CardHorizontalState extends State<CardHorizontal> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: (widget.onTap != null ? widget.elevation : 0),
        color: (widget.onTap != null
            ? Colors.white
            : Color.fromRGBO(216, 216, 216, 1)),
        child: Padding(
          padding: EdgeInsets.only(
              top: widget.padding,
              bottom: widget.padding,
              left: widget.padding,
              right: 1),
          // padding: EdgeInsets.all(widget.padding),
          child: Stack(
            children: [
              if (widget.useChevron && widget.onTap != null)
                Positioned(
                    top: -13,
                    right: -5,
                    child: TextButton(
                        onPressed: () {},
                        child: const Icon(Icons.chevron_right,
                            color: Colors.black38))),
              if (!widget.useChevron && widget.onTap != null)
                Positioned(
                  top: 0,
                  right: 10,
                  child: Badge(
                    elevation: 0,
                    position: BadgePosition.topEnd(top: 0, end: 3),
                    animationDuration: const Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    toAnimate: true,
                    shape: BadgeShape.circle,
                    borderRadius: BorderRadius.circular(20),
                    badgeColor: Colors.transparent,
                    badgeContent: const Icon(
                      Icons.expand_more,
                      size: 15,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.icon != null) widget.icon!,
                      if (widget.icon != null)
                        const SizedBox(
                          width: 5.0,
                        ),
                      Text(widget.text,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
