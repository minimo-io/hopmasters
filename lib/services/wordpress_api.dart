import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:Hops/models/news.dart';
import 'package:Hops/views/orders/ordersView.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'dart:collection';

import 'package:Hops/helpers.dart';

import 'package:Hops/secrets.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/customer.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/models/brewery.dart';
import 'package:Hops/models/preferences.dart';
import 'package:Hops/models/order_data.dart';
import 'package:Hops/services/shared_services.dart';

import 'package:location/location.dart';

class WordpressAPI {
  static String _apiKey = WC_CONSUMER_KEY;
  static String _apiSecret = WC_CONSUMER_SECRET;

  static String _WP_BASE_API = "https://hops.uy/wp-json";
  static String _WP_JWT_AUTH_URI = "/jwt-auth/v1/token";
  static String _WP_REST_WP_URI = "/wp/v2/";
  static String _WP_REST_WP_COMMENTS = "comments";
  static String _WP_REST_WP_BARS = "bares";
  static String _WP_REST_WP_PROMOS = "promos";
  static String _WP_REST_WP_NEWS = "posts";

  static String _WP_REST_WC_URI = "/wc/v3/"; // for WooCommerce
  static String _WP_REST_WC_CUSTOMER = "customers";
  static String _WP_REST_WP_PAYMENTS = "payment_gateways";
  static String _WP_REST_WC_CATEGORIES = "products/categories";
  static String _WP_REST_WC_ORDERS = "orders";

  static String _WP_REST_HOPS_URI = "/hops/v1/"; // custom endpoint for Hops

  static const String MESSAGE_ERROR_LOGIN =
      "¡Ups! Login incorrecto. Vuelve a intentarlo o ponete en contacto con atención al cliente.";
  static const String MESSAGE_ERROR_USER_ALREADY_EXISTS =
      "¡Ups! Ya existe un registro. Intenta ingresar en vez de registrarte.";
  static const String MESSAGE_ERROR_LOGIN_UNEXPECTED =
      "Ups! Ocurrió un error intentando ingresar. Ponete en contacto.";

  static const String MESSAGE_THANKS_FOR_SIGNUP =
      "¡Hola cervecer@! Gracias por registrate.";
  static const String MESSAGE_OK_LOGIN_BACK =
      "¿Hay sed en el cuadro? ¡Que bueno verte de vuelta!";

  static const String MESSAGE_ERROR_UPDATING_PREFS =
      "¡Ups! Ocurrió un error actualizando las preferencias. Ponete en contacto.";
  static const String MESSAGE_OK_UPDATING_PREFS =
      "¡Copiado! A descubrir cervezas.";

  static const String MESSAGE_OK_FOLLOWING_BREWERY =
      "¡Buena elección! Te mantendremos al tanto de las novedades.";
  static const String MESSAGE_ERROR_FOLLOWING_BREWERY =
      "¡Ups! Ocurrió un error. Ponete en contacto.";

  static const String MESSAGE_OK_UNFOLLOWING_BREWERY =
      "Es verdad, menos es mas.";
  static const String MESSAGE_ERROR_UNFOLLOWING_BREWERY =
      "¡Ups! Ocurrió un error. Ponete en contacto.";

  static const String MESSAGE_OK_ADDCOMMENT = "¡Opinión publicada!";
  static const String MESSAGE_ERROR_ADDEDITCOMMENT = "¡Ocurrió un error: ";

  static const String MESSAGE_OK_EDITCOMMENT =
      "Cambiar de opinión es de sabios. ¡Opinión modificada!";

  static const String MESSAGE_ERROR_CREATEORDER =
      "Ocurrió un error al intentar crear la orden. Por favor ponete en contacto.";
  static const String MESSAGE_OK_CREATEORDER =
      "¡Pedido recibido! En breve te contactamos para entregártelo.";

  static Future<bool> login(String? username, String? password,
      {String? customAvatar, String connectionType = "Email"}) async {
    bool ret = false;

    try {
      var response = await Dio().post(
        _WP_BASE_API + _WP_JWT_AUTH_URI,
        data: {"username": username, "password": password},
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );

      if (response.statusCode == 200) {
        // if response from REST API is correct then add extra fields to response
        if (response.data["statusCode"] == 200) {
          // if there is a customar avatar to subtitue the one comming from
          // woocommerce then subtitute it
          if (customAvatar != null)
            response.data["data"]["avatarUrl"] = customAvatar;
          response.data["data"]["connectionType"] = connectionType;
        }
        // print(response.data);
        LoginResponse loginResponse = loginResponseFromJson(response.data);

        if (loginResponse.statusCode == 200) {
          SharedServices.setLoginDetails(loginResponse);
        }

        return loginResponse.statusCode == 200 ? true : false;
      }
    } on DioError catch (e) {
      print("Duplicate ID:" + e.response!.statusMessage.toString());
      ret = false;
    }

    return ret;
  }

  // instead of the first function this returns a Map with more details
  static Future<Map<String, dynamic>> signUp(Customer customer) async {
    var authToken = base64.encode(utf8.encode(_apiKey + ":" + _apiSecret));
    Map<String, dynamic> ret = new Map();
    ret["result"] = false;
    ret["status"] = "ERROR_UNKNOWN";

    try {
      var response = await Dio().post(
        _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_CUSTOMER,
        data: customer.toJson(),
        options: new Options(headers: {
          HttpHeaders.authorizationHeader: 'basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json"
        }),
      );

      if (response.statusCode == 201) {
        ret["result"] = true;
        ret["status"] = "OK_USERCREATED";
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        ret["result"] = false;
        ret["status"] = "ERROR_ALREADYEXISTS";
      } else {
        ret["result"] = false;
        ret["status"] = "ERROR_STATUSCODE_" + e.response!.statusCode.toString();
      }
    }
    return ret;
  }

  static Future getBeersFromBreweryID(String breweryID) async {
    final String beersFromBreweryUriQuery = _WP_BASE_API +
        _WP_REST_HOPS_URI +
        "beers/breweryID/" +
        breweryID +
        "?_embed";
    print(beersFromBreweryUriQuery);
    try {
      var response = await Dio().get(
        beersFromBreweryUriQuery,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        //var jsonResponse = json.decode(response.body);
        var jsonResponse = response.data;
        return jsonResponse;
      }
    } on DioError catch (e) {
      print('Failed to load beers!');
      throw Exception('Failed to load beers!');
    }
  }

  // get beer from products
  static Future<Beer?> getBeer(String beerId, {String? userId = "0"}) async {
    String beerUriQuery = _WP_BASE_API +
        _WP_REST_WC_URI +
        "products/" +
        beerId +
        "?_embed&consumer_key=" +
        _apiKey +
        "&consumer_secret=" +
        _apiSecret;
    // add user to get comments if any
    if (userId != null && userId != "0")
      beerUriQuery = beerUriQuery + "&userId=" + userId;

    print(beerUriQuery);

    try {
      var response = await Dio().get(
        beerUriQuery,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        // send query to increase the beer views_count
        WordpressAPI.increaseViewCount(int.parse(beerId), type: 'beer');

        // return response
        var jsonResponse = response.data;
        return Beer.fromJson(jsonResponse);
      }
    } on DioError catch (e) {
      print('Failed to load beer!');
      throw Exception('Failed to load beer');
    }
  }

  // get list of beers
  static Future increaseViewCount(int postId, {String? type = "beer"}) async {
    final String queryUri =
        _WP_BASE_API + _WP_REST_HOPS_URI + "increaseViewsCount";

    // print(queryUri);

    try {
      var response = await Dio().post(
        queryUri,
        data: {
          "postType": type,
          "postId": postId.toString(),
        },
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      print('Failed to load breweries list!');
      throw Exception('Failed to load breweries list!');
    }
  }

  // get list of beers
  static Future getBeers(
      {String? userBeers = null,
      String type = 'user_beers',
      String? userId = "0",
      String? extraParam1 = "",
      int? page = 1}) async {
    String beersUriQuery = _WP_BASE_API +
        _WP_REST_WC_URI +
        "products/?_embed&consumer_key=" +
        _apiKey +
        "&consumer_secret=" +
        _apiSecret;
    if (userId != null && userId != "0")
      beersUriQuery = beersUriQuery + "&userId=" + userId;
    if (userBeers != null && type == "user_beers")
      beersUriQuery += "&include=" + userBeers.replaceAll("|", ",");
    // get recent
    if (type == "recent")
      beersUriQuery += "&order=desc&order_by=date&status=publish";
    // trend
    if (type == "trends")
      beersUriQuery =
          _WP_BASE_API + _WP_REST_HOPS_URI + "beers/trending?_embed";
    // most_voted
    if (type == "most_voted")
      beersUriQuery =
          _WP_BASE_API + _WP_REST_HOPS_URI + "beers/mostVoted?_embed";
    // premium or sponsored beers
    if (type == "premium")
      beersUriQuery = _WP_BASE_API + _WP_REST_HOPS_URI + "beers/premium?_embed";
    // ibu
    if (type == "ibu")
      beersUriQuery = _WP_BASE_API +
          _WP_REST_HOPS_URI +
          "beers/ibu?extraParam1=" +
          extraParam1! +
          "&_embed";
    // price
    if (type == "price")
      beersUriQuery = _WP_BASE_API +
          _WP_REST_HOPS_URI +
          "beers/price?extraParam1=" +
          extraParam1! +
          "&_embed";
    // abv
    if (type == "abv")
      beersUriQuery = _WP_BASE_API +
          _WP_REST_HOPS_URI +
          "beers/abv?extraParam1=" +
          extraParam1! +
          "&_embed";

    // add page
    beersUriQuery = beersUriQuery + "&page=" + page.toString();

    print(beersUriQuery);

    try {
      var response = await Dio().get(
        beersUriQuery,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      print('Failed to load beers!');
      throw Exception('Failed to load beers!');
    }
  }

  // get list of breweries
  static Future getBreweries(
      {String? userBreweries = null,
      String? orderType = null,
      int? page = 1}) async {
    String breweryUriQuery =
        _WP_BASE_API + _WP_REST_WP_URI + "pages/?parent=89109";
    if (userBreweries != null)
      breweryUriQuery += "&include=" + userBreweries.replaceAll("|", ",");
    if (orderType != null && orderType == "followers")
      breweryUriQuery += "&orderType=followers";

    // add pagination
    breweryUriQuery = breweryUriQuery + "&page=" + page.toString();
    print(breweryUriQuery);

    try {
      var response = await Dio().get(
        breweryUriQuery,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      print(e);
      print('Failed to load breweries list!');
      throw Exception('Failed to load breweries list!');
    }
  }

  static Future<Brewery?> getBrewery(String breweryId,
      {String? userId = "0"}) async {
    String breweryUriQuery =
        _WP_BASE_API + _WP_REST_WP_URI + "pages/" + breweryId + "?";
    if (userId != null && userId != "0")
      breweryUriQuery = breweryUriQuery + "&userId=" + userId;

    if (DEBUG) print(breweryUriQuery);

    try {
      var response = await Dio().get(
        breweryUriQuery,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        // send query to increase the brewery views_count
        WordpressAPI.increaseViewCount(int.parse(breweryId), type: 'brewery');

        // return stuff
        var jsonResponse = response.data;
        Brewery brewery = Brewery.fromJson(jsonResponse);
        return brewery;
      }
    } on DioError catch (e) {
      if (DEBUG) print('Failed to load brewery data!');
      throw Exception('Failed to load brewery data!');
    }
  }

  static Map<String, dynamic> generateNameFromDisplayName(String displayName) {
    Map<String, dynamic> userName = new Map();

    userName["firstName"] = displayName;
    userName["lastName"] = '';

    List displayNameList = displayName.split(" ");
    // if display name is like "George Costanza"
    if (displayNameList.length == 2) {
      userName["firstName"] = displayNameList[0];
      userName["lastName"] = displayNameList[1];
    }
    return userName;
  }

  static String generatePassword(String initialValue) {
    var pwdBytes = utf8.encode(initialValue + SECRET_SAUCE);
    String pwd = sha256.convert(pwdBytes).toString();
    return pwd;
  }

  static Future<List<dynamic>?> getPrefsOptions() async {
    // https://hops.uy/wp-json/wc/v3/products/categories
    //print( _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_CATEGORIES + "?page=1&per_page=30&parent=0&orderby=count&consumer_key="+ _apiKey +"&consumer_secret=" + _apiSecret);
    try {
      var response = await Dio().get(
        _WP_BASE_API +
            _WP_REST_WC_URI +
            _WP_REST_WC_CATEGORIES +
            "?page=1&per_page=30&parent=0&orderby=count&consumer_key=" +
            _apiKey +
            "&consumer_secret=" +
            _apiSecret,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        //var jsonResponse = json.decode(response.body);
        List<dynamic> jsonResponse = response.data;
        return jsonResponse;
      }
    } on DioError catch (e) {
      return [];
      print(e.message);
    }
  }

  static Future<bool> setPrefsOptions(
      int userId,
      UnmodifiableListView<Pref> userPreferences,
      UnmodifiableListView<Pref> userNewsPreferences) async {
    final String beersFromBreweryUriQuery =
        _WP_BASE_API + _WP_REST_HOPS_URI + "updateUser";
    //print(beersFromBreweryUriQuery);
    //print(jsonDecode(jsonUserPreferences));
    String beerTypes = "";
    for (var i = 0; i < userPreferences.length; i++) {
      if (beerTypes != "") beerTypes += "|";
      beerTypes += userPreferences[i].id.toString();
    }

    String newsPrefs = "";
    for (var i = 0; i < userNewsPreferences.length; i++) {
      if (newsPrefs != "") newsPrefs += "|";
      newsPrefs += userNewsPreferences[i].id.toString();
    }
    /*
    print(beerTypes);
    print(newsPrefs);
    print(userId);
    */
    try {
      var response = await Dio().post(
        beersFromBreweryUriQuery,
        data: {
          "updateType": "preferences",
          "userId": userId.toString(),
          "beerTypesPrefs": beerTypes,
          "newsPrefs": newsPrefs
        },
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null
            ? jsonResponse["result"]
            : false);
      }
    } on DioError catch (e) {
      //print('Failed to set user preferences! ' + e.message);
      throw Exception('Failed to set user preferences!' + e.message);
    }
    return true;
  }

  /// Add or remove beer (favorite) from user breweries prefs
  static Future<bool> editBreweryPref(int userId, int breweryId,
      {String addOrRemove = "add"}) async {
    final String beersFromBreweryUriQuery =
        _WP_BASE_API + _WP_REST_HOPS_URI + "updateUser";
    //print(beersFromBreweryUriQuery);
    if (addOrRemove != "add" && addOrRemove != "remove") return false;

    Map<String, dynamic> dataMap = {
      "updateType": "breweriesPreferences",
      "userId": userId.toString(),
      "breweryId": breweryId.toString(),
      "addOrRemove": addOrRemove
    };

    try {
      var response = await Dio().post(
        beersFromBreweryUriQuery,
        data: dataMap,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null
            ? jsonResponse["result"]
            : false);
      }
    } on DioError catch (e) {
      //print('Failed to set user preferences! ' + e.message);
      throw Exception('Failed to set brewery preferences!' + e.message);
    }
    return true;
  }

  /// Add or remove beer (favorite) from user beers prefs, acf: beers_favorites_preference
  static Future<bool> editBeerPref(int userId, int beerId,
      {String addOrRemove = "add"}) async {
    final String beersFromBreweryUriQuery =
        _WP_BASE_API + _WP_REST_HOPS_URI + "updateUser";
    //print(beersFromBreweryUriQuery);
    if (addOrRemove != "add" && addOrRemove != "remove") return false;

    Map<String, dynamic> dataMap = {
      "updateType": "beersFavoritesPreference",
      "userId": userId.toString(),
      "beerId": beerId.toString(),
      "addOrRemove": addOrRemove
    };

    try {
      var response = await Dio().post(
        beersFromBreweryUriQuery,
        data: dataMap,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null
            ? jsonResponse["result"]
            : false);
      }
    } on DioError catch (e) {
      //print('Failed to set user preferences! ' + e.message);
      throw Exception('Failed to set brewery preferences!' + e.message);
    }
    return true;
  }

  /// Get user preferences from custom fields
  static Future<Map<String, dynamic>?> getUserPrefs(int? userId,
      {String indexType = "breweries_preferences"}) async {
    //print(_WP_BASE_API + _WP_REST_HOPS_URI + "getUser/userID/" + userId.toString() + "/" + indexType + "/");
    try {
      var response = await Dio().get(
        _WP_BASE_API +
            _WP_REST_HOPS_URI +
            "getUser/userID/" +
            userId.toString() +
            "/" +
            indexType +
            "/",
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data;
        return jsonResponse;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }

  /// Add or remove beer (favorite) from user beers prefs, acf: beers_favorites_preference
  static Future<Map<String, dynamic>> addEditComment(
      int userId, int postId, String? userComment,
      {
      // String beerOrBrewery = "beer",
      String? commentId = "1",
      double? rating = 0}) async {
    final String uriQuery = _WP_BASE_API + _WP_REST_HOPS_URI + "updateComment";
    //print(uriQuery);

    Map<String, dynamic> dataMap = {
      "commentId": (commentId != null ? commentId : "0"),
      "userId": userId.toString(),
      "postId": postId.toString(),
      "rating": rating.toString(),
      // "beerOrBrewery": beerOrBrewery,
      "userComment": (userComment != null ? userComment : '')
    };

    try {
      var response = await Dio().post(
        uriQuery,
        data: dataMap,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.data;

        //print(jsonResponse);

        return {
          "result":
              (jsonResponse["result"] != null ? jsonResponse["result"] : false),
          "data": (jsonResponse["data"]["comment"] != null
              ? jsonResponse["data"]["comment"]
              : ""),
          "opinionCount": (jsonResponse["opinionCount"] != null
              ? jsonResponse["opinionCount"]
              : "0"),
          "opinionScore": (jsonResponse["opinionScore"] != null
              ? jsonResponse["opinionScore"]
              : "0.0"),
        };
        //return ;
      }
    } on DioError catch (e) {
      if (e.response!.data.runtimeType != String) {
        return {"result": false, "data": e.response!.data["code"].toString()};
      } else {
        return {"result": false, "data": "comment_already_exists"};
      }
    }
    return {"result": false, "data": ""};
  }

  /// Get comments from postId
  static Future<List<dynamic>?> getComments(int? postId) async {
    //print( _WP_BASE_API + _WP_REST_WP_URI + _WP_REST_WP_COMMENTS + "/?post=" + postId.toString() + "&order=desc&orderby=date_gmt", );
    try {
      var response = await Dio().get(
        _WP_BASE_API +
            _WP_REST_WP_URI +
            _WP_REST_WP_COMMENTS +
            "/?post=" +
            postId.toString() +
            "&order=desc&orderby=date_gmt",
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }

  static Future<bool> createOrder(OrderData newOrder) async {
    final String orderQueryUri =
        _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WC_ORDERS;

    var authToken = base64.encode(utf8.encode(_apiKey + ":" + _apiSecret));

    Map<String, dynamic> dataMap = newOrder.toJson();
    // print(dataMap);

    try {
      var response = await Dio().post(
        orderQueryUri,
        data: dataMap,
        options: new Options(headers: {
          HttpHeaders.authorizationHeader: 'basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json"
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        return (jsonResponse["result"] != null
            ? jsonResponse["result"]
            : false);
      }
    } on DioError catch (e) {
      //print('Failed to set user preferences! ' + e.message);
      print(e.response!.data.toString());
      throw Exception('Failed to create order!' + e.message);
    }
    return true;
  }

  // get user orders
  static Future<List<dynamic>?> getOrders(int? customerId,
      {String? status = "any", int? orderId}) async {
    String query = _WP_BASE_API +
        _WP_REST_WC_URI +
        _WP_REST_WC_ORDERS +
        "/?customer=" +
        customerId.toString() +
        "&order=desc&orderby=date&per_page=100&page=1";
    query =
        query + "&consumer_key=" + _apiKey + "&consumer_secret=" + _apiSecret;

    if (status != null) query = query + "&status=" + status;
    if (orderId != null) query = query + "&include=" + orderId.toString();

    if (DEBUG) print(query);

    try {
      var response = await Dio().get(
        query,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }

  // get bars
  static Future<List<dynamic>?> getBars({LocationData? location}) async {
    String query = _WP_BASE_API +
        _WP_REST_WP_URI +
        _WP_REST_WP_BARS +
        "/?_embed&order=desc&orderby=date&per_page=100&page=1";
    query =
        query + "&consumer_key=" + _apiKey + "&consumer_secret=" + _apiSecret;
    print(location.toString());
    if (location != null) {
      query = query +
          "&location=" +
          location.latitude.toString() +
          "|" +
          location.longitude.toString();
    }

    print(query);

    try {
      var response = await Dio().get(
        query,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }

  // get promos
  static Future<List<dynamic>?> getPromos({LocationData? location}) async {
    String query = _WP_BASE_API +
        _WP_REST_WP_URI +
        _WP_REST_WP_PROMOS +
        "/?_embed&order=desc&orderby=date&per_page=100&page=1";
    query =
        query + "&consumer_key=" + _apiKey + "&consumer_secret=" + _apiSecret;
    /*
    print(location.toString());
    if ( location != null) {
      query = query + "&location=" + location.latitude.toString() + "|" + location.longitude.toString();
    }
     */
    print("PROMOS QUERY");
    print(query);

    try {
      var response = await Dio().get(
        query,
        options: new Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
      print(e.message);
    }
  }

  // get promos
  static Future<List<dynamic>?> getPayments() async {
    String query =
        _WP_BASE_API + _WP_REST_WC_URI + _WP_REST_WP_PAYMENTS + "/?order=desc";
    query =
        query + "&consumer_key=" + _apiKey + "&consumer_secret=" + _apiSecret;
    /*
    print(location.toString());
    if ( location != null) {
      query = query + "&location=" + location.latitude.toString() + "|" + location.longitude.toString();
    }
     */
    print("PAYMENTS QUERY");
    print(query);

    try {
      var response = await Dio().get(
        query,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
    }
  }

  static Future<List<dynamic>?> search({String? query}) async {
    // String searchQuery = _WP_BASE_API +
    //     _WP_REST_WC_URI +
    //     "products/?_embed&fields=name&search=" +
    //     query! +
    //     "&consumer_key=" +
    //     _apiKey +
    //     "&consumer_secret=" +
    //     _apiSecret;

    String searchQuery = _WP_BASE_API +
        "/wp/v2/search?search=" +
        query! +
        "&type=post&subtype=page,product,bares"; // promos, tiendas,locales

    if (DEBUG) print(searchQuery);
    try {
      var response = await Dio().get(
        searchQuery,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );
      if (DEBUG) print(searchQuery);
      if (response.statusCode == 200) {
        if (DEBUG) print(response.data);

        return response.data;
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
    }
  }

  static Future<List<News>> getNews({int count = 2}) async {
    String newsQuery = _WP_BASE_API + _WP_REST_WP_URI + _WP_REST_WP_NEWS;
    newsQuery += "?orderby=date&per_page=" + count.toString() + "&page=1";
    if (DEBUG) print("News query: " + newsQuery);
    try {
      var response = await Dio().get(
        newsQuery,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        return News.allFromResponse(response.data);
      } else {
        return <News>[];
      }
    } on DioError catch (e) {
      return jsonDecode("{}");
    }
  }
}
