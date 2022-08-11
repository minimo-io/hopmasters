import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';

import 'package:Hops/views/login/components/connect_socials.dart';
import 'package:Hops/views/login/components/login_page.dart';
import 'package:Hops/views/login/components/signup_page.dart';

class LoginView extends StatefulWidget {
  // login goes without slash at the moment, in order to avoid loading / assets
  static const String routeName = "login";
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final BoxDecoration _headerDecoration = BoxDecoration(
    image: DecorationImage(
        image: const AssetImage("assets/images/beer_bg_bw2.png"),
        //fit: BoxFit.scaleDown,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop)),
    gradient: PRIMARY_GRADIENT_COLOR,
  );

  final PageController _controller =
      PageController(initialPage: 2, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: Container(
            //height: MediaQuery.of(context).size.height,
            child: PageView(
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            LoginPage(
              controller: _controller,
              headerDecoration: _headerDecoration,
            ),
            SignupPage(
              controller: _controller,
              headerDecoration: _headerDecoration,
            ),
            ConnectSocialsPage(
              controller: _controller,
              headerDecoration: _headerDecoration,
            )
          ],
          scrollDirection: Axis.vertical,
        )),
      ),
    );
  }
}
