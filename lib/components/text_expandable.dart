import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

class TextExpandable extends StatefulWidget {
  bool? isExpanded;
  String text;
  int linesToShow;
  Widget? callToActionWidget;
  double? fontSize;
  double? mainFontSize;

  TextExpandable(this.text,
      {this.linesToShow = 3,
      this.isExpanded = false,
      this.callToActionWidget,
      this.fontSize = 13,
      this.mainFontSize = 13.5,
      Key? key})
      : super(key: key);

  @override
  _TextExpandableState createState() => _TextExpandableState();
}

class _TextExpandableState extends State<TextExpandable> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded!;
  }

  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  Widget _buildExpandableButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: Helpers.screenAwareSize(5.0, context),
        left: Helpers.screenAwareSize(0.0, context),
      ),
      child: GestureDetector(
        onTap: _expand,
        child: Text(
          isExpanded ? 'Leer menos' : 'Leer mas',
          style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
              fontSize: widget.fontSize),
        ),
      ),
    );
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
                fontFamily: 'Montserrat-Medium',
                fontSize: widget.mainFontSize),
          ),
          secondChild: Text(
            widget.text,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(
                height: 1.3,
                color: SECONDARY_TEXT_DARK.withOpacity(0.8),
                //fontSize: Helpers.screenAwareSize(10.0, context),
                fontSize: widget.mainFontSize,
                fontFamily: 'Montserrat-Medium'),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
        if (widget.callToActionWidget != null)
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Helpers.screenAwareSize(5.0, context),
                  left: Helpers.screenAwareSize(0.0, context),
                ),
                child: widget.callToActionWidget!,
              ),
              const SizedBox(
                width: 10,
              ),
              _buildExpandableButton(),
            ],
          ),
        if (widget.callToActionWidget == null) _buildExpandableButton(),
      ],
    );
  }
}
