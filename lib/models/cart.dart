import 'dart:collection';
import 'dart:convert';
import 'package:Hops/models/brewery.dart';
import 'package:flutter/foundation.dart';
import 'package:Hops/models/beer.dart';
import 'package:flutter/rendering.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];
  // final List<Brewery> _breweries = [];

  List<CartItem> get items => _items;
  List<Brewery> get breweries => getBreweriesFromCart();

  /// convert all preferences to json for then sending it to server
  String get toJson => jsonEncode(_items.map((e) => e.toJson()).toList());

  void add(CartItem item) {
    // items.add(item);

    bool beerAlreadyInCart = false;
    for (var i = 0; i < _items.length; i++) {
      if (item.beer!.beerId == _items[i].beer!.beerId) {
        beerAlreadyInCart = true;
        break;
      }
    }

    if (beerAlreadyInCart) {
      // increase amount, the number of items added
      for (var i = 1; i <= item.itemCount; i++) {
        modifyAmount(item, "increase");
      }
    } else {
      // else add for the first time
      items.add(item);
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void modifyAmount(CartItem item, String type) {
    //_items.where((element) => element.beer!.beerId == item.beer!.beerId);
    for (var i = 0; i < _items.length; i++) {
      if (item.beer!.beerId == _items[i].beer!.beerId) {
        // print("INCREASE AMOUNT OF: " + _items[i].beer!.name.toString());
        if (type == "increase") _items[i].itemCount++;
        if (type == "decrease") _items[i].itemCount--;
        _items[i].itemPrice =
            _items[i].itemCount * double.parse(_items[i].beer!.price!);
        if (_items[i].itemPrice < 0) _items[i].itemPrice = 0;
        notifyListeners();
        break;
      }
    }
  }

  double finalPrice() {
    double finalPrice = 0.0;
    for (var i = 0; i < _items.length; i++) {
      // if (item.beer!.beerId == _items[i].beer!.beerId){
      finalPrice += _items[i].itemPrice;
    }
    return finalPrice;
  }

  void remove(CartItem item) {
    //print(_items);
    //_items.remove(pref);
    _items.removeWhere((element) => element.beer!.beerId == item.beer!.beerId);
    notifyListeners();
  }

  /// Removes all items from the beer type items
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  List getShippingList() {
    List shippingList = [];
    for (var i = 0; i < _items.length; i++) {
      shippingList.add({
        "product_id": _items[i].beer!.beerId,
        "quantity": _items[i].itemCount,
      });
    }
    return shippingList;
  }

  List<Brewery> getBreweriesFromCart() {
    List<Brewery> breweriesList = [];
    for (var i = 0; i < _items.length; i++) {
      // if (item.beer!.beerId == _items[i].beer!.beerId) {
      //   // print("INCREASE AMOUNT OF: " + _items[i].beer!.name.toString());
      //   if (type == "increase") _items[i].itemCount++;
      //   if (type == "decrease") _items[i].itemCount--;
      //   _items[i].itemPrice =
      //       _items[i].itemCount * double.parse(_items[i].beer!.price!);
      //   if (_items[i].itemPrice < 0) _items[i].itemPrice = 0;
      //   notifyListeners();
      //   break;
      // }
      print(_items[i].beer!.breweryName);
      // breweriesList.add(

      // );
    }
    return [];
  }
}

class CartItem {
  int itemCount;
  double itemPrice;
  Beer? beer;

  CartItem({this.itemCount = 1, this.itemPrice = 0.0, this.beer});

  factory CartItem.fromJson(Map<String, dynamic> parsedJson) {
    return CartItem(
        itemCount: parsedJson["itemCount"],
        itemPrice: parsedJson["itemPrice"],
        beer: parsedJson["beer"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'itemCount': itemCount,
      'itemPrice': itemPrice,
      'beer': beer,
    });
    return map;
  }
}
