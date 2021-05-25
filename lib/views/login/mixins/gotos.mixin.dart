import 'package:flutter/material.dart';

// Common functions for PageController pages to share the goto functions
mixin GotosMixin<T extends StatefulWidget> on State<T>{
  void gotoLogin(PageController controller){
    controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }
  void gotoSignUp(PageController controller){
    controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }
}