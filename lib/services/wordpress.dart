import 'package:http/http.dart' as http;
import 'dart:convert';

final apiBaseUri = 'https://hopmasters.net/wp-json/';

Future topBeers() async{
  final response = await http.get(apiBaseUri, headers: {
    'Accept': 'application/json'
  });

  print(response.body);

  final responseJson = jsonDecode(response.body);
  return responseJson;
}