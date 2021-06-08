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


  BoxDecoration _headerDecoration = BoxDecoration(
    /*
    image: DecorationImage(
        image: AssetImage('assets/images/bg5.png'),
        fit: BoxFit.fill
    ),

     */
    image: DecorationImage(
      image: AssetImage("assets/images/decoration.png"),
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop)
    ),
    gradient: PRIMARY_GRADIENT_COLOR,
  );

  PageController _controller = new PageController(initialPage: 2, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: Container(
        //height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            LoginPage(
              controller: _controller,
              headerDecoration: _headerDecoration ,
            ),
            SignupPage(
              controller: _controller,
              headerDecoration: _headerDecoration ,
            ),
            ConnectSocialsPage(
              controller: _controller,
              headerDecoration: _headerDecoration ,
            )
          ],
          scrollDirection: Axis.vertical,
        )),
      ),
    );
  }
}

