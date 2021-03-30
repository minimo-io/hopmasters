import 'package:flutter/material.dart';
import 'package:hopmasters/constants.dart';
// import 'package:shop_app/screens/home/home_screen.dart';
// import 'package:shop_app/screens/profile/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final HopsMenuState selectedMenu;


  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Opacity(
                opacity: 0.5,
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.pushNamed(context, "/favs");
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, "/store");
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () => Navigator.pushNamed(context, "/account")
              ),
            ],
          )),
    );
  }
}