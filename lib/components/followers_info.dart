import 'package:flutter/material.dart';

class FollowersInfo extends StatelessWidget {
  final String followers;
  final Color textColor;
  const FollowersInfo(this.followers, {this.textColor = const Color(0xBBFFFFFF)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(this.followers ?? "0" + ' seguidores', style: TextStyle(color: this.textColor, fontSize: 18, fontWeight: FontWeight.bold), ),
        ],
      ),
    );
  }

}
