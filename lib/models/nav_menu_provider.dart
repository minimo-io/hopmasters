import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NavMenuProvider extends ChangeNotifier{
  int _currentIndex = 0; // home is default
  final List<String> _items = ["/"];

  UnmodifiableListView<String> get items => UnmodifiableListView(_items);


  get currentIndex => _currentIndex;
  set currentIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }
  void setCurrentIndex(int index){
    this._currentIndex = index;
    notifyListeners();
  }

  void add(String item) {

    if ( ! _items.contains(item) ){
      _items.add(item);
      // This call tells the widgets that are listening to this model to rebuild.
      notifyListeners();
    }

  }

  void remove(String item) {
    if (_items.contains(item) ){
      _items.remove(item);
      // This call tells the widgets that are listening to this model to rebuild.
      notifyListeners();
    }

  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }


}