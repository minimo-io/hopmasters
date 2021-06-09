import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String? text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          child: new ConstrainedBox(
              constraints: widget.isExpanded
                  ? new BoxConstraints()
                  : new BoxConstraints(maxHeight: 70.0),
              child: new Text(
                widget.text!,
                softWrap: true,
                overflow: TextOverflow.fade,
                  style: TextStyle(color: SECONDARY_TEXT_DARK.withOpacity(0.8), height: 1.3),
              ))),
      widget.isExpanded
          ? new ConstrainedBox(constraints: new BoxConstraints())
          : new IconButton(icon: Icon(Icons.expand_more), color: Colors.black54.withOpacity(0.5),onPressed: () => setState(() => widget.isExpanded = true)),

    ]);
  }
}