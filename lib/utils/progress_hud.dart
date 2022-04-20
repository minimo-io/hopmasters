import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {

  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color>? valueColor;
  final String? text;

  ProgressHUD({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            /*child: new CircularProgressIndicator(
              color: PROGRESS_INDICATOR_COLOR,
              valueColor: valueColor,
            ),*/
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image.asset("assets/images/loader-hops.gif",width: 100,),
              if (text != null) Padding(padding:EdgeInsets.only(top:10), child: Material(child:Text(text!), type: MaterialType.transparency,) ),

             ],)


          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}