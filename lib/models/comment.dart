/// Comment class for product & breweries & posts review

class Comment{
  String? comment_ID;
  String? comment_post_ID;
  String? comment_author;
  String? comment_author_email;
  String? comment_author_url;
  String? comment_author_IP;
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

    comment_ID = json["comment_ID"];
    comment_post_ID = json["comment_post_ID"];
    comment_author = json["comment_author"];
    comment_author_email = json["comment_author_email"];
    comment_author_url = json["comment_author_url"];
    comment_author_IP = json["comment_author_IP"];
    comment_date = json["comment_date"];
    comment_date_gmt = json["comment_date_gmt"];
    comment_content = json["comment_content"];
    comment_karma = json["comment_karma"];
    comment_approved = json["comment_approved"];
    comment_agent = json["comment_agent"];
    comment_type = json["comment_type"];
    comment_parent = json["comment_parent"];
    user_id = json["user_id"];
    rating = json["comment_rating"];

  }
  
}