import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/components/stars_score.dart';

import 'package:Hops/models/comment.dart';
import 'package:Hops/helpers.dart';

class CommentsView extends StatefulWidget {
  static const String routeName = "/comments";

  int postId;
  String? postTitle;

  CommentsView({
    Key? key,
    this.postId = 0,
    this.postTitle
  }) : super(key: key);

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  late Future<List<dynamic>?>? _futureComments;

  void initState(){

    _futureComments = WordpressAPI.getComments(this.widget.postId);
  }

  Widget _buildCommentBox(Comment comment){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Hero(
              tag: "comment-"+comment.comment_ID!,
              child: Image.network(
                comment.comment_author_avatar!,
                fit: BoxFit.cover, // this is the solution for border
                width: 55.0,
                height: 55.0,
              ),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.comment_author!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left),
                      SizedBox(height: 3,),
                      Text(
                          Helpers.parseHtmlString(comment.comment_content!),
                          style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.2),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left
                      ),
                      StarsScore(
                        opinionCount: 0,
                        opinionScore: double.parse(comment.rating!),
                        onlyStars: true
                      )
                    ]
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: double.infinity, maxHeight: double.infinity),
            child: FutureBuilder(
                  future: _futureComments,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,),
                          ],
                        );
                      default:
                        if (snapshot.hasError) {
                          return Text('Error Comment: ${snapshot.error}');
                        }else {
                          /*
                          List<Comment> commentsList = snapshot.data.map((data) => Comment.fromJson(data)).toList();
                          print(commentsList);
                          */
                          // List comments = Comment.allFromResponse(snapshot);
                          List<Widget> commentsCardList = <Widget>[];
                          for(var i = 0; i < snapshot.data.length; i++){

                            Comment comment = Comment.fromJson(snapshot.data[i]);
                            commentsCardList.add( _buildCommentBox( comment ));

                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0, left:8, right:8 ),
                            child: Column(children: commentsCardList,),
                          );
                        }
                    }
                  }
                ),
                // SizedBox(height: MediaQuery.of(context).size.height,),

          ),
        ),
      ),
      appBar: AppBar(
          title: Text("Opiniones" + ( widget.postTitle != null ? " sobre " + widget.postTitle! : "" ))
      ),
    );
  }
}