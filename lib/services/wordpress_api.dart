import 'package:hopmasters/models/login.dart';
import 'package:http/http.dart' as http;

class WordpressAPI{
  /*
  const String WP_BASE_API = "https://hops.uy";
  const String WP_REST_VERSION_URI = "/wp-json/wp/v2/";
  const String WP_REST_WC_VERSION_URI = "/wp-json/wc/v3/"; // for WooCommerce
  const String WP_REST_HOPS_VERSION_URI = "/wp-json/hops/v1/"; // custom endpoint for WooCommerce
  */
  static const String _WP_BASE_API = "https://hops.uy/wp-json/";
  static const String _WP_REST_WP_URI = "/wp/v2/";
  static const String _WP_REST_WC_URI = "/wc/v3/"; // for WooCommerce
  static const String _WP_REST_HOPS_URI = "/hops/v1/"; // custom endpoint for Hops

  static var client = http.Client();

  static Future<bool> loginCustomer(String username, String password) async{
    Map<String,String>  requestHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var response = await client.post(
      "$_WP_BASE_API/jwt-auth/v1/token",
      headers: requestHeaders,
      body: {
        "username": username,
        "password": password
      }
    );

    if (response.statusCode == 200){
      var jsonString = response.body;
      LoginResponse loginResponse = loginResponseFromJson(jsonString);
      return loginResponse.statusCode == 200 ? true : false;
    }

    return false;
  }

}