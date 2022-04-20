/// Comment class for product & breweries & posts review

class Comment{
  String? comment_ID;
  String? comment_post_ID;
  String? comment_author;
  String? comment_author_email;
  String? comment_author_url;
  String? comment_author_IP;
  String? comment_author_avatar;
  String? comment_date;
  String? comment_date_gmt;
  String? comment_content;
  String? comment_karma;
  String? comment_approved;
  String? comment_agent;
  String? comment_type;
  String? comment_parent;
  String? user_id;
  String? rating;

  Comment({
    this.comment_ID,
    this.comment_post_ID,
    this.comment_author,
    this.comment_author_email,
    this.comment_author_url,
    this.comment_author_IP,
    this.comment_author_avatar,
    this.comment_date,
    this.comment_date_gmt,
    this.comment_content,
    this.comment_karma,
    this.comment_approved,
    this.comment_agent,
    this.comment_type,
    this.comment_parent,
    this.user_id,
    this.rating
  });

  Comment.fromJson( Map<String, dynamic> json){

    comment_ID = (json["comment_ID"] != null ? json["comment_ID"] : json["id"].toString() );

    comment_post_ID = (json["comment_post_ID"] != null ? json["comment_post_ID"] : json["post"].toString() );
    comment_author = (json["comment_author"] != null ? json["comment_author"] : json["author_name"].toString() );
    comment_author_email = json["comment_author_email"];
    comment_author_url = (json["comment_author_url"] != null ? json["comment_author_url"] : json["author_url"] );
    comment_author_avatar = (json["author_avatar_urls"] != null ? json["author_avatar_urls"]["24"] : null );
    comment_author_IP = json["comment_author_IP"];
    comment_date = (json["comment_date"] != null ? json["comment_date"] : json["date"] );
    comment_date_gmt = (json["comment_date_gmt"] != null ? json["comment_date_gmt"] : json["date_gmt"] );
    comment_content = (json["comment_content"] != null ? json["comment_content"] : json["content"]["rendered"] );
    comment_karma = json["comment_karma"];
    comment_approved = (json["comment_approved"] != null ? json["comment_approved"] : json["status"] );
    comment_agent = json["comment_agent"];
    comment_type = (json["comment_type"] != null ? json["comment_type"] : json["type"] );
    comment_parent = (json["comment_parent"] != null ? json["comment_parent"] : json["parent"].toString() );
    user_id = (json["user_id"] != null ? json["user_id"] : json["author"].toString() );
    rating = (json["comment_rating"] != null ? json["comment_rating"] : ( json["acf"] is Map == true ? json["acf"]["score"] : "0") );
  }



  static List<Comment> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Comment.fromJson(obj))
        .toList()
        .cast<Comment>();
  }


}