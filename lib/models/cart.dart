import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier{

  final List<CartItem> _items = [];

  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  /// convert all preferences to json for then sending it to server
  String get toJson => jsonEncode(_items.map((e) => e.toJson()).toList());

  /// Adds [preference] to the basket. This and [removeAll] are the only ways to modify the
  void add(CartItem item) {
    print("Cart item added");
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }


  void remove(CartItem item){
    //print(_items);
    //_items.remove(pref);
    _items.removeWhere((element) => element.itemId == item.itemId);
    notifyListeners();
  }


  /// Removes all items from the beer type items
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}


class CartItem{

  int itemId, itemCount;
  String itemName, itemImage;
  double itemPrice;

  String breweryImage;
  String breweryName;

  CartItem({
    this.itemId = 0,
    this.itemName = "",
    this.itemPrice = 0.0,
    this.itemCount = 1,
    this.itemImage = "",
    this.breweryImage = "",
    this.breweryName = ""
  });

  factory CartItem.fromJson(Map<String, dynamic> parsedJson){
    return CartItem(
        itemId: parsedJson["itemId"],
        itemName: parsedJson["itemName"],
        itemPrice: parsedJson["itemPrice"],
        itemCount: parsedJson["itemCount"],
        itemImage: parsedJson["itemImage"],
        breweryImage: parsedJson["breweryImage"],
        breweryName: parsedJson["breweryName"],

    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    map.addAll({
      'itemId': itemId,
      'itemName': itemName,
      'itemPrice': itemPrice,
      'itemCount': itemCount,
      'itemImage': itemImage,
      'breweryImage': breweryImage,
      'breweryName': breweryName,
    });
    return map;
  }
}