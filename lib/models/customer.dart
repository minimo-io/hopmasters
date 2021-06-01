
class Customer{
  String email;
  String firstName;
  String lastName;
  String password;
  String avatar;

  Customer({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.avatar
  });

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email,
      'avatar': avatar
    });
    return map;
  }
}