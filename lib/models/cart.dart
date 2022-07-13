import 'dart:collection';
import 'dart:convert';
import 'package:Hops/models/brewery.dart';
import 'package:Hops/models/order_data.dart';
import 'package:flutter/foundation.dart';
import 'package:Hops/models/beer.dart';
import 'package:flutter/rendering.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];
  // final List<Brewery> _breweries = [];

  List<CartItem> get items => _items;
  int get itemsCount => getItemsCount();
  List<Brewery> get breweries => getBreweriesFromCart();

  /// convert all preferences to json for then sending it to server
  String get toJson => jsonEncode(_items.map((e) => e.toJson()).toList());

  bool get validateSell => isValidSell();

  double get totalDeliveryCost => getDeliveryCost();

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

  int finalPrice({int? breweryId}) {
    double finalPrice = 0.0;
    for (var i = 0; i < _items.length; i++) {
      double beerPrice = 0.0;
      // if first promo exists then use the discountedItemPrice
      if (_items[i].beer!.brewery.promos != null &&
          _items[i].beer!.brewery.promos!.isNotEmpty) {
        double discountValue =
            items[i].beer!.brewery.promos!.first.discountValue;

        beerPrice += discountedItemPrice(_items[i].itemPrice, discountValue);
      } else {
        beerPrice += _items[i].itemPrice;
      }
      // decide whether to sum or not depending on the fn param
      bool doSum = false;
      if (breweryId == null) {
        doSum = true;
      } else {
        if (breweryId == int.parse(items[i].beer!.brewery.id)) {
          doSum = true;
        }
      }

      if (doSum) finalPrice += beerPrice;
    }
    return finalPrice.round();
  }

  // double breweryFinalPrice() {
  //   double finalPrice = 0.0;

  //   return finalPrice.round();
  // }

  double discountedItemPrice(double itemValue, double discountValue) {
    // for no only percentage
    double discountPercentage = ((discountValue * itemValue) / 100);
    return itemValue - discountPercentage;
  }

  int countBreweryItems(int breweryId) {
    int breweryCount = 0;
    for (var i = 0; i < _items.length; i++) {
      // if (item.beer!.beerId == _items[i].beer!.beerId){

      if (breweryId == int.parse(_items[i].beer!.brewery.id)) {
        breweryCount += _items[i].itemCount;
      }
    }

    return breweryCount;
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

  List getShippingList({Brewery? brewery}) {
    List shippingList = [];
    for (var i = 0; i < _items.length; i++) {
      bool addToShipping = false;
      if (brewery != null) {
        if (_items[i].beer!.brewery.id == brewery.id) addToShipping = true;
      } else {
        addToShipping = true;
      }

      if (addToShipping) {
        double totalPrice = _items[i].itemPrice;
        // add total with discount if exits
        if (_items[i].beer!.brewery.promos != null &&
            _items[i].beer!.brewery.promos!.isNotEmpty) {
          double discountValue =
              _items[i].beer!.brewery.promos!.first.discountValue;
          double discountedValue =
              discountedItemPrice(_items[i].itemPrice, discountValue);
          totalPrice = discountedValue;
        }

        shippingList.add({
          "product_id": _items[i].beer!.beerId,
          "quantity": _items[i].itemCount,
          "total": totalPrice.toString(),
        });
      }
    }
    return shippingList;
  }

  List<Brewery> getBreweriesFromCart() {
    List<Brewery> breweriesList = [];
    for (var i = 0; i < _items.length; i++) {
      if (!breweriesList
          .any((Brewery brewery) => brewery.id == _items[i].beer!.brewery.id)) {
        breweriesList.add(_items[i].beer!.brewery);
      }
    }
    return breweriesList;
  }

  int getItemsCount() {
    int itemsCount = 0;
    for (var i = 0; i < _items.length; i++) {
      // if (item.beer!.beerId == _items[i].beer!.beerId){
      itemsCount += _items[i].itemCount;
    }
    return itemsCount;
  }

  double getDeliveryCost() {
    double totalDeliveryCost = 0.0;
    List<Brewery> breweries = getBreweriesFromCart();
    for (var i = 0; i < breweries.length; i++) {
      totalDeliveryCost += double.parse(breweries[i].deliveryCost.toString());
    }
    return totalDeliveryCost;
  }

  bool isValidSell() {
    bool isValid = false;
    // check amount of beers for each brewery
    List<Brewery> breweries = getBreweriesFromCart();
    for (var i = 0; i < breweries.length; i++) {
      int breweryMinAmount = breweries[i].deliveryMin ?? 3;
      int breweryItemsCount = countBreweryItems(int.parse(breweries[i].id));

      if (breweryMinAmount <= breweryItemsCount) {
        isValid = true;
      } else {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  bool isShippingDataOk(OrderData? orderData) {
    if (orderData == null) {
      return false;
    } else {
      return true;
    }
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
