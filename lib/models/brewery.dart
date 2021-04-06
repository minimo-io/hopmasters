import 'dart:convert';
import 'package:meta/meta.dart';

class Brewery {
  Brewery({
    @required this.avatar,
    @required this.name,
    @required this.email,
    @required this.location,
    @required this.description
  });

  final String avatar;
  final String name;
  final String email;
  final String location;
  final String description;

  static List<Brewery> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Brewery.fromMap(obj))
        .toList()
        .cast<Brewery>();
  }

  static Brewery fromMap(Map map) {
    var name = map['name'];

    return new Brewery(
      avatar: map['picture']['large'],
      name: '${_capitalize(name['first'])} ${_capitalize(name['last'])}',
      email: map['email'],
      location: _capitalize(map['location']['state']),
    );
  }

  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
