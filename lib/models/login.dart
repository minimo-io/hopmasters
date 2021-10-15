LoginResponse loginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse.fromJson(json);

class LoginResponse{
  bool? success;
  int? statusCode;
  String? code;
  String? message;
  Data? data;

  LoginResponse({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data
  });

  LoginResponse.fromJson( Map<String, dynamic> json){

    success = json["success"];
    statusCode = json["statusCode"];
    code = json["code"];
    message = json["message"];
    data = json["data"].length > 0 ? new Data.fromJson(json["data"]) : null;
  }


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["success"] = this.success;
    data["statusCode"] = this.statusCode;
    data["code"] = this.code;
    data["message"] = this.message;
    if (this.data != null){
      data["data"] = this.data!.toJson();
    }
    return data;
  }


}

class Data{
  String? token;
  int? id;
  String? email;
  String? nicename;
  String? firstname;
  String? lastname;
  String? displayName;
  String? avatarUrl;
  String? connectionType;
  String? score;

  Data({
    this.token,
    this.id,
    this.email,
    this.nicename,
    this.firstname,
    this.lastname,
    this.displayName,
    this.avatarUrl,
    this.connectionType,
    this.score,
  });

  Data.fromJson( Map<String, dynamic> json ){
    token  = json["token"];
    id  = json["id"];
    email  = json["email"];
    nicename  = json["nicename"];
    firstname  = json["firstname"];
    lastname  = json["lastname"];
    displayName  = json["displayName"];
    avatarUrl = json["avatarUrl"];
    connectionType = (json["connectionType"] != null ? json["connectionType"] : null );
    score = json["score"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.nicename;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['displayName'] = this.displayName;
    data['avatarUrl'] = this.avatarUrl;
    data['connectionType'] = this.connectionType;
    data['score'] = this.score;
    return data;
  }
}