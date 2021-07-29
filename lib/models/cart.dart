import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:Hops/models/beer.dart';

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
  
  void modifyAmount(CartItem item, String type ){
    //_items.where((element) => element.beer!.beerId == item.beer!.beerId);
    for (var i = 0; i<_items.length; i++){
      if (item.beer!.beerId == _items[i].beer!.beerId){
        // print("INCREASE AMOUNT OF: " + _items[i].beer!.name.toString());
        if (type == "increase") _items[i].itemCount++;
        if (type == "decrease") _items[i].itemCount--;
        _items[i].itemPrice = _items[i].itemCount * double.parse(_items[i].beer!.price!);
        if (_items[i].itemPrice < 0) _items[i].itemPrice = 0;
        notifyListeners();
        break;
      }

    }
  }

  double finalPrice(){
    double finalPrice = 0.0;
    for (var i = 0; i<_items.length; i++){

      // if (item.beer!.beerId == _items[i].beer!.beerId){
      finalPrice += _items[i].itemPrice;

    }
    return finalPrice;
  }

  void remove(CartItem item){
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

}


class CartItem{

  int itemCount;
  double itemPrice;
  Beer? beer;


  CartItem({
    this.itemCount = 1,
    this.itemPrice = 0.0,
    this.beer
  });

  factory CartItem.fromJson(Map<String, dynamic> parsedJson){
    return CartItem(
        itemCount: parsedJson["itemCount"],
        itemPrice: parsedJson["itemPrice"],
        beer: parsedJson["beer"]
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    map.addAll({
      'itemCount': itemCount,
      'itemPrice': itemPrice,
      'beer': beer,
    });
    return map;
  }


}