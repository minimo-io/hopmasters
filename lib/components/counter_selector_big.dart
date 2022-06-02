import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

class CounterSelectorBig extends StatefulWidget {
  Color? color = Color(0xFF525663);
  dynamic Function(int itemCount)? notifyParent;
  int? counterInitCount;
  EdgeInsetsGeometry? counterPadding;

  CounterSelectorBig(
      {this.color,
      @required this.notifyParent,
      this.counterInitCount = 1,
      this.counterPadding,
      Key? key})
      : super(key: key);

  @override
  _CounterSelectorState createState() => _CounterSelectorState();
}

class _CounterSelectorState extends State<CounterSelectorBig> {
  int _counter = 1;
  String _beersString = "cerveza";
  final double _buttonsFontSize = 30.0;
  final double _textFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _counter = widget.counterInitCount!;
    if (_counter > 1) _beersString = "cervezas";
  }

  void _increase() {
    setState(() {
      _counter++;
      if (_counter > 1) _beersString = "cervezas";
    });
    if (widget.notifyParent != null) widget.notifyParent!(_counter);
  }

  void _decrease() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
      if (_counter == 1) _beersString = "cerveza";
    });
    if (widget.notifyParent != null) widget.notifyParent!(_counter);
  }

  _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: (widget.counterPadding != null
            ? widget.counterPadding!
            : const EdgeInsets.all(12.0)),
        child: Container(
          //width: MediaQuery.of(context).size.width - 100,
          //         .size
          //         .width,
          height: Helpers.screenAwareSize(45.0, context),
          decoration: BoxDecoration(
              //color: widget.color?.withOpacity(0.8),
              color: const Color.fromRGBO(222, 222, 222, 1),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  color: widget.color,
                  icon: Icon(Icons.remove_circle, size: _buttonsFontSize),
                  onPressed: _decrease,
                ),
              ),

              // _divider(),
              Flexible(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  child: Center(
                      child: Text(
                    "$_counter $_beersString",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: _textFontSize,
                        fontFamily: 'Montserrat-Bold'),
                  )),
                ),
              ),
              // _divider(),

              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(
                    color: widget.color,
                    // color: Colors.black54,
                    Icons.add_circle,
                    size: _buttonsFontSize,
                  ),
                  onPressed: _increase,
                ),
              ),
              // Flexible(
              //   flex: 3,
              //   child: GestureDetector(
              //     onTap: _increase,
              //     child: Container(
              //       height: double.infinity,
              //       child: Center(
              //         child: Text(
              //           '+',
              //           style: TextStyle(
              //               color: Colors.black54,
              //               fontSize: _buttonsFontSize,
              //               fontFamily: 'Montserrat-Bold'),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
