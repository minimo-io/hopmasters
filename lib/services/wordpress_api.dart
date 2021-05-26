import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:hopmasters/helpers.dart';

import 'package:hopmasters/models/login.dart';
import 'package:hopmasters/models/customer.dart';
import 'package:hopmasters/models/beer.dart';
import 'package:hopmasters/models/brewery.dart';

class WordpressAPI{

  static String _apiKey = "ck_ee520942f86cce196bac817417f19fe92aa1a838";
  static String _apiSecret = "cs_7bd786d6d4a996e4657d14bfb4abdfa30a5597dd";


  static String _WP_BASE_API = "https://hops.uy/wp-json";
  static String _WP_JWT_AUTH_URI = "/jwt-auth/v1/token";
  static String _WP_REST_WP_URI = "/wp/v2/";
  static String _WP_REST_WC_URI = "/wc/v3/"; // for WooCommerce
    static String _WP_REST_WC_CUSTOMER = "customers";
  static String _WP_REST_HOPS_URI = "/hops/v1/"; // custom endpoint for Hops


  static Future<bool> login(String username, String password) async{
    Map<String,String>  requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded'
    };
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
        LoginResponse loginResponse = loginResponseFromJson(response.data);
        return loginResponse.statusCode == 200 ? true : false;
      }

    }on DioError catch (e){

      print("Duplicate email ID:" + e.response.statusMessage.toString());
      ret = false;

    }

    return ret;
  }

  static Future<bool> signUp(Customer customer)async{
    var authToken = base64.encode(utf8.encode(_apiKey + ":" + _apiSecret));
    bool ret = false;

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
        ret = true;
      }
    } on DioError catch(e) {
      if (e.response.statusCode == 404){
        print("Duplicate email ID.");
        ret = false;
      }else{
        ret = false;
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
  static Future<Beer> getBeer(String beerId)async{
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

  static Future<Brewery> getBrewery(String breweryId)async{
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

}