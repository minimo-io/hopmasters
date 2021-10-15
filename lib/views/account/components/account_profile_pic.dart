import 'package:flutter/material.dart';

class BreweryProfilePic extends StatelessWidget {
  String? avatarUrl, score;
  BreweryProfilePic({
    Key? key,
    String? this.avatarUrl,
    String? this.score,
  }) : super(key: key);

   _buildAvatar(){
    if (this.avatarUrl != null){
      return NetworkImage(this.avatarUrl!);
    }else{
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
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: Row(
                  children:[
                    //Icon(Icons.sports_bar, size: 15,),
                    Image.asset("assets/images/medal.png", height: 20,),
                    SizedBox(width: 0),
                    Text(this.score.toString(), style: TextStyle(fontSize: 13),)
                  ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}