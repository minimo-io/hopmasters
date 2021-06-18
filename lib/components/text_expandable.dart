import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

class TextExpandable extends StatefulWidget {
  bool? isExpanded;
  String text;
  int linesToShow;

  TextExpandable(
    this.text,
    {
      this.linesToShow = 3,
      this.isExpanded = false,
      Key? key
    }) : super(key: key);

  @override
  _TextExpandableState createState() => _TextExpandableState();
}

class _TextExpandableState extends State<TextExpandable> {
  bool isExpanded = false;

  @override
  void initState(){
    this.isExpanded = widget.isExpanded!;
  }


  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.linesToShow,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(
                height: 1.3,
                color: SECONDARY_TEXT_DARK.withOpacity(0.8),
                //fontSize: Helpers.screenAwareSize(10.0, context),
                fontFamily: 'Montserrat-Medium'),
          ),
          secondChild: Text(
            widget.text,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(
                height: 1.3,
                color: SECONDARY_TEXT_DARK.withOpacity(0.8),
                //fontSize: Helpers.screenAwareSize(10.0, context),
                fontFamily: 'Montserrat-Medium'),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Helpers.screenAwareSize(5.0, context),
            left: Helpers.screenAwareSize(0.0, context),
          ),
          child: GestureDetector(
            onTap: _expand,
            child: Text(
              isExpanded ? 'Leer menos' : 'Leer mas',
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
