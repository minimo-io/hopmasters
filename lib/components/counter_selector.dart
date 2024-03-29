import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

class CounterSelector extends StatefulWidget {
  Color? color = Color(0xFF525663);
  dynamic Function(int itemCount)? notifyParent;
  int? counterInitCount;
  EdgeInsetsGeometry? counterPadding;

  CounterSelector(
      {this.color,
      @required this.notifyParent,
      this.counterInitCount = 1,
      this.counterPadding,
      Key? key})
      : super(key: key);

  @override
  _CounterSelectorState createState() => _CounterSelectorState();
}

class _CounterSelectorState extends State<CounterSelector> {
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    _counter = widget.counterInitCount!;
  }

  void _increase() {
    setState(() {
      _counter++;
    });
    if (widget.notifyParent != null) widget.notifyParent!(_counter);
  }

  void _decrease() {
    setState(() {
      if (_counter > 1) _counter--;
    });
    if (widget.notifyParent != null) widget.notifyParent!(_counter);
  }

  _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (widget.counterPadding != null
          ? widget.counterPadding!
          : EdgeInsets.all(12.0)),
      child: Container(
        width: Helpers.screenAwareSize(100.0, context),
        height: Helpers.screenAwareSize(37.0, context),
        decoration: BoxDecoration(
            //color: widget.color?.withOpacity(0.8),
            color: Color.fromRGBO(222, 222, 222, 1),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: _decrease,
                  child: Container(
                    height: double.infinity,
                    child: Center(
                      child: Text('-',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontFamily: 'Montserrat-Bold')),
                    ),
                  ),
                )),
            _divider(),
            Flexible(
              flex: 3,
              child: Container(
                height: double.infinity,
                child: Center(
                    child: Text(
                  _counter.toString(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontFamily: 'Montserrat-Bold'),
                )),
              ),
            ),
            _divider(),
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: _increase,
                child: Container(
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontFamily: 'Montserrat-Bold'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
