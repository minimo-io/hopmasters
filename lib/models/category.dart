import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';



class Preferences extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Category> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Category> get items => UnmodifiableListView(_items);

  /// convert all preferences to json for then sending it to server
  String get toJson => jsonEncode(_items.map((e) => e.toJson()).toList());


  /// Adds [preference] to the basket. This and [removeAll] are the only ways to modify the
  void add(Category pref) {
    _items.add(pref);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(Category pref){
    _items.remove(pref);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}

class Category {
  int? id;
  String? name;
  String? slug;
  int? parent;
  String? description;
  String? display;
  String? image;
  int? menu_order;
  int? count;
  bool isSelected = false;


  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    required this.image,
    required this.menu_order,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> parsedJson){
    return Category(
      id: parsedJson["id"],
      name: parsedJson["name"],
      slug: parsedJson["slug"],
      parent: parsedJson["parent"],
      description: parsedJson["description"],
      display: parsedJson["display"],
      image: parsedJson["image"],
      menu_order: parsedJson["menu_order"],
      count: parsedJson["count"]

    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    map.addAll({
      'id': id,
      'name': name,
      'slug': slug,
      'parent': parent,
      'description': description,
      'display': display,
      'image': image,
      'menu_order': menu_order,
      'count': count,
    });
    return map;
  }

  static List<Category> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Category.fromJson(obj))
        .toList()
        .cast<Category>();
  }


}
