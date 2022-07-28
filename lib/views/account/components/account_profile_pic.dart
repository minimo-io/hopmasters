import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/wordpress_api.dart';

class BreweryProfilePic extends StatefulWidget {
  String? avatarUrl;
  int? userId;
  BreweryProfilePic({
    Key? key,
    String? this.avatarUrl,
    int? this.userId,
  }) : super(key: key);

  @override
  _BreweryProfilePicState createState() => _BreweryProfilePicState();
}

class _BreweryProfilePicState extends State<BreweryProfilePic> {
  _buildAvatar() {
    if (this.widget.avatarUrl != null) {
      return NetworkImage(this.widget.avatarUrl!);
    } else {
      return AssetImage("assets/images/profile-test.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: _buildAvatar(),
          ),
          Positioned(
            right: 15,
            bottom: 0,
            child: SizedBox(
              height: 30,
              width: 80,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: Row(children: [
                  //Icon(Icons.sports_bar, size: 15,),
                  Image.asset(
                    "assets/images/medal.png",
                    height: 20,
                  ),

                  FutureBuilder(
                      future: WordpressAPI.getUserPrefs(widget.userId,
                          indexType: "score"),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: PROGRESS_INDICATOR_COLOR,
                                strokeWidth: 1.0,
                              ),
                            ));
                          default:
                            if (snapshot.hasError) {
                              return Text(' Ups! Errors: ${snapshot.error}');
                            } else {
                              String scoreResult =
                                  snapshot.data["result"].toString();
                              if (scoreResult.isEmpty) scoreResult = "0";
                              return Text(
                                scoreResult,
                                style: const TextStyle(fontSize: 13),
                              );
                            }
                        }
                      })
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
