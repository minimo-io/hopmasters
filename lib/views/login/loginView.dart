import 'package:flutter/material.dart';

import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/views/login/components/connect_socials.dart';

import 'package:hopmasters/views/login/components/login_page.dart';
import 'package:hopmasters/views/login/components/signup_page.dart';


class LoginView extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {


  BoxDecoration _headerDecoration = BoxDecoration(

    image: DecorationImage(
        image: AssetImage('assets/images/bg5.png'),
        fit: BoxFit.fill
    ),
    gradient: PRIMARY_GRADIENT_COLOR,
  );

  PageController _controller = new PageController(initialPage: 2, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

