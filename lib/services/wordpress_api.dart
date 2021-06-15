import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'dart:collection';

import 'package:Hops/helpers.dart';

import 'package:Hops/secrets.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/customer.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/models/brewery.dart';
import 'package:Hops/models/preferences.dart';
import 'package:Hops/services/shared_services.dart';

class WordpressAPI{

  static String _apiKey = WC_CONSUMER_KEY;
  static String _apiSecret = WC_CONSUMER_SECRET;


  static String _WP_BASE_API = "https://hops.uy/wp-json";
  static String _WP_JWT_AUTH_URI = "/jwt-auth/v1/token";
  static String _WP_REST_WP_URI = "/wp/v2/";
  static String _WP_REST_WC_URI = "/wc/v3/"; // for WooCommerce
    static String _WP_REST_WC_CUSTOMER = "customers";
    static String _WP_REST_WC_CATEGORIES = "products/categories";
  static String _WP_REST_HOPS_URI = "/hops/v1/"; // custom endpoint for Hops

  static const String MESSAGE_ERROR_LOGIN = "¡Ups! Login incorrecto. Vuelve a intentarlo o ponete en contacto con atención al cliente.";
  static const String MESSAGE_ERROR_USER_ALREADY_EXISTS = "¡Ups! Ya existe un registro. Intenta ingresar en vez de registrarte.";
  static const String MESSAGE_ERROR_LOGIN_UNEXPECTED = "Ups! Ocurrió un error intentando ingresar. Ponete en contacto.";

  static const String MESSAGE_THANKS_FOR_SIGNUP = "¡Hola cervecer@! Gracias por registrate.";
  static const String MESSAGE_OK_LOGIN_BACK = "¡Que bueno es verte de vuelta!";

  static const String MESSAGE_ERROR_UPDATING_PREFS = "¡Ups! Ocurrió un error actualizando las preferencias. Ponete en contacto.";
  static const String MESSAGE_OK_UPDATING_PREFS = "¡Copiado! A descubrir cervezas.";

  static const String MESSAGE_OK_FOLLOWING_BREWERY = "¡Buena elección! Te mantendremos al tanto de las novedades.";
  static const String MESSAGE_ERROR_FOLLOWING_BREWERY = "¡Ups! Ocurrió un error. Ponete en contacto.";

  static const String MESSAGE_OK_UNFOLLOWING_BREWERY = "Ok, es verdad, menos es mas ¡Suerte!";
  static const String MESSAGE_ERROR_UNFOLLOWING_BREWERY = "¡Ups! Ocurrió un error. Ponete en contacto.";

  static Future<bool> login(
      String? username,
      String? password,
      { String? customAvatar, String connectionType = "Email" }
      ) async{

    bool ret = false;

    try{
      var response = await Dio().post(
        _WP_BASE_API + _WP_JWT_AUTH_URI,
        data: {
          "username": username,
          "password": password
        },
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
            }
        ),
      );

      if (response.statusCode == 200){

        // if response from REST API is correct then add extra fields to response
        if (response.data["statusCode"] == 200){
          // if there is a customar avatar to subtitue the one comming from
          // woocommerce then subtitute it
          if (customAvatar != null) response.data["data"]["avatarUrl"] = customAvatar;
          response.data["data"]["connectionType"] = connectionType;
        }

        LoginResponse loginResponse = loginResponseFromJson(response.data);

        if (loginResponse.statusCode == 200){
          SharedServices.setLoginDetails(loginResponse);
        }

        return loginResponse.statusCode == 200 ? true : false;
      }

    }on DioError catch (e){

      print("Duplicate ID:" + e.response!.statusMessage.toString());
      ret = false;

    }

    return ret;
  }

  // instead of the first function this returns a Map with more details
  static Future<Map<String, dynamic>> signUp(Customer customer)async{
    var authToken = base64.encode(utf8.encode(_apiKey + ":" + _apiSecret));
    Map<String,dynamic> ret = new Map();
    ret["result"] = false;
    ret["status"] = "ERROR_UNKNOWN";

    try{
      var response = await Dio().post(
        _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_CUSTOMER,
        data: customer.toJson(),
        options: new Options(
            headers: {
              HttpHeaders.authorizationHeader: 'basic $authToken',
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 201){
        ret["result"] = true;
        ret["status"] = "OK_USERCREATED";
      }
    } on DioError catch(e) {
      if (e.response!.statusCode == 400){
        ret["result"] = false;
        ret["status"] = "ERROR_ALREADYEXISTS";
      }else{
        ret["result"] = false;
        ret["status"] = "ERROR_STATUSCODE_"+e.response!.statusCode.toString();
      }
    }
    return ret;
  }
  static Future getBeersFromBreweryID(String breweryID)async{
    final String beersFromBreweryUriQuery = _WP_BASE_API + _WP_REST_HOPS_URI + "beers/breweryID/"+ breweryID +"?_embed";

    try{
      var response = await Dio().get(
        beersFromBreweryUriQuery,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){
        //var jsonResponse = json.decode(response.body);
        var jsonResponse = response.data;
        return jsonResponse;


      }

    } on DioError catch(e) {
      print('Failed to load beers!');
      throw Exception('Failed to load beers!');
    }


  }

  // get beer from products
  static Future<Beer?> getBeer(String beerId)async{
    final String beerUriQuery = _WP_BASE_API + _WP_REST_WC_URI + "products/"+ beerId +"?_embed&consumer_key="+ _apiKey +"&consumer_secret=" + _apiSecret;

    try{
      var response = await Dio().get(
        beerUriQuery,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){
        var jsonResponse = response.data;

        return Beer(
          beerId: beerId,
          //image: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
          image: jsonResponse["images"][0]["src"],
          followers: jsonResponse['acf']['followers'],
          name: jsonResponse['name'],
          bgColor: jsonResponse['acf']['bg_color'],
          //description: jsonResponse['short_description'],
          description: Helpers.parseHtmlString(jsonResponse['description']),
          abv: jsonResponse['acf']['abv'],
          ibu: jsonResponse['acf']['ibu'],
          launch: jsonResponse['acf']['launch'],
          price: jsonResponse['price'],
          type: jsonResponse['categories'][0]['name'],
          size: jsonResponse['acf']['container'],
          breweryId: jsonResponse['acf']['brewery']['ID'].toString(),
          breweryName: jsonResponse['acf']['brewery']['post_title'],
          breweryImage: jsonResponse['acf']['brewery_image'],

        );


      }

    } on DioError catch(e) {
      print('Failed to load beer!');
      throw Exception('Failed to load beer');
    }


  }

  // get list of breweries
  static Future getBreweries()async{
    final String breweryUriQuery = _WP_BASE_API + _WP_REST_WP_URI + "pages/?parent=89109&_embed";

    try{
      var response = await Dio().get(
        breweryUriQuery,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){
        return response.data;
      }
    } on DioError catch(e) {
      print('Failed to load breweries list!');
      throw Exception('Failed to load breweries list!');
    }


  }

  static Future<Brewery?> getBrewery(String breweryId)async{
    final String breweryUriQuery = _WP_BASE_API + _WP_REST_WP_URI + "pages/"+ breweryId +"?_embed";

    try{
      var response = await Dio().get(
        breweryUriQuery,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){

        var jsonResponse = response.data;

        Brewery brewery = Brewery(
          id: breweryId,
          avatar: jsonResponse["_embedded"]["wp:featuredmedia"][0]["media_details"]["sizes"]["thumbnail"]["source_url"],
          location: jsonResponse['acf']['location'],
          followers: jsonResponse['acf']['followers'],
          beersCount: jsonResponse['acf']['beers_count'],
          bgColor: jsonResponse['acf']['bg_color'],
          name: jsonResponse['title']['rendered'],
          description: jsonResponse['excerpt']['rendered'],
        );

        return brewery;


      }
    } on DioError catch(e) {
      print('Failed to load brewery data!');
      throw Exception('Failed to load brewery data!');
    }


  }

  static Map<String, dynamic> generateNameFromDisplayName(String displayName){
    Map<String, dynamic> userName = new Map();
    userName["firstName"] = displayName;
    userName["lastName"] = '';

    List displayNameList = displayName.split(" ");
    // if display name is like "George Costanza"
    if (displayNameList.length == 2){
      userName["firstName"] = displayNameList[0];
      userName["lastName"] = displayNameList[1];
    }
    return userName;
  }

  static String generatePassword(String initialValue){
    var pwdBytes = utf8.encode(initialValue + SECRET_SAUCE);
    String pwd = sha256.convert(pwdBytes).toString();
    return pwd;
  }

  static Future<List<dynamic>?> getPrefsOptions()async {
    // https://hops.uy/wp-json/wc/v3/products/categories
    //print( _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_CATEGORIES + "?page=1&per_page=30&parent=0&orderby=count&consumer_key="+ _apiKey +"&consumer_secret=" + _apiSecret);
    try{
      var response = await Dio().get(
        _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_CATEGORIES + "?page=1&per_page=30&parent=0&orderby=count&consumer_key="+ _apiKey +"&consumer_secret=" + _apiSecret,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){
        //var jsonResponse = json.decode(response.body);
        List<dynamic> jsonResponse = response.data;
        return jsonResponse;


      }
    } on DioError catch(e) {
      return [];
      print(e.message);
    }
  }

  static Future<bool> setPrefsOptions(int userId, UnmodifiableListView<Pref> userPreferences, UnmodifiableListView<Pref> userNewsPreferences)async{

    final String beersFromBreweryUriQuery = _WP_BASE_API + _WP_REST_HOPS_URI + "updateUser";
    //print(beersFromBreweryUriQuery);
    //print(jsonDecode(jsonUserPreferences));
    String beerTypes = "";
    for(var i = 0; i< userPreferences.length; i++) {
      if (beerTypes != "") beerTypes += "|";
      beerTypes += userPreferences[i].id.toString();
    }

    String newsPrefs = "";
    for(var i = 0; i< userNewsPreferences.length; i++) {
      if (newsPrefs != "") newsPrefs += "|";
      newsPrefs += userNewsPreferences[i].id.toString();
    }
    /*
    print(beerTypes);
    print(newsPrefs);
    print(userId);
    */
    try{

      var response = await Dio().post(
        beersFromBreweryUriQuery,
        data: {
          "updateType": "preferences",
          "userId" : userId.toString(),
          "beerTypesPrefs": beerTypes,
          "newsPrefs": newsPrefs
        },
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
            }
        ),
      );

      if (response.statusCode == 200){
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null ? jsonResponse["result"]  : false);
      }

    } on DioError catch(e) {
      //print('Failed to set user preferences! ' + e.message);
      throw Exception('Failed to set user preferences!' + e.message);
    }
    return true;
  }

  /// Add or remove beer (favorite) from user breweries prefs
  static Future<bool> editBreweryPref(
  int userId,
  int breweryId,
  { String addOrRemove = "add" }
  )async{

    final String beersFromBreweryUriQuery = _WP_BASE_API + _WP_REST_HOPS_URI + "updateUser";
    //print(beersFromBreweryUriQuery);
    if (addOrRemove != "add" && addOrRemove != "remove") return false;

    Map<String, dynamic> dataMap = {
      "updateType": "breweriesPreferences",
      "userId" : userId.toString(),
      "breweryId": breweryId.toString(),
      "addOrRemove": addOrRemove
    };

    try{

      var response = await Dio().post(
        beersFromBreweryUriQuery,
        data: dataMap,
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
            }
        ),
      );
      if (response.statusCode == 200){
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null ? jsonResponse["result"]  : false);
      }

    } on DioError catch(e) {
      //print('Failed to set user preferences! ' + e.message);
      throw Exception('Failed to set brewery preferences!' + e.message);
    }
    return true;
  }

  /// Get user preferences from custom fields
  static Future<Map<String, dynamic>?> getUserPrefs( int? userId, {String indexType = "breweries_preferences" } )async {
    //print(_WP_BASE_API + _WP_REST_HOPS_URI + "getUser/userID/" + userId.toString() + "/" + indexType + "/");
    try{
      var response = await Dio().get(
        _WP_BASE_API + _WP_REST_HOPS_URI + "getUser/userID/" + userId.toString() + "/" + indexType + "/",
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json"
            }
        ),
      );

      if (response.statusCode == 200){

        Map<String, dynamic> jsonResponse = response.data;

        //print(jsonResponse);
        return jsonResponse;


      }
    } on DioError catch(e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }


}