import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';



class Preferences extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Pref> _items = [];
  final List<Pref> _itemsNews = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Pref> get items => UnmodifiableListView(_items);
  /// Return a string with the ids of the item selection
  String get itemsIds{
    String items = "";
    for(var i = 0; i< this.items.length; i++) {
      if (items != "") items += "|";
      items += this.items[i].id.toString();
    }
    return items;
  }
  String get newsItemsIds{
    String items = "";
    for(var i = 0; i< this.itemsNews.length; i++) {
      if (items != "") items += "|";
      items += this.itemsNews[i].id.toString();
    }
    return items;
  }

  UnmodifiableListView<Pref> get itemsNews => UnmodifiableListView(_itemsNews);

  /// convert all preferences to json for then sending it to server
  String get toJson => jsonEncode(_items.map((e) => e.toJson()).toList());

  /// convert all preferences to json for then sending it to server
  String get toJsonNews => jsonEncode(_itemsNews.map((e) => e.toJson()).toList());


  /// Adds [preference] to the basket. This and [removeAll] are the only ways to modify the
  void add(Pref pref) {
    _items.add(pref);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addNews(Pref pref) {
    _itemsNews.add(pref);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(Pref pref){
    //print(_items);
    //_items.remove(pref);
    _items.removeWhere((element) => element.id == pref.id);
    notifyListeners();
  }

  void removeNews(Pref pref){
    //_itemsNews.remove(pref);
    _itemsNews.removeWhere((element) => element.id == pref.id);
    notifyListeners();
  }

  /// Removes all items from the beer type items
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the news
  void removeAllNews() {
    _itemsNews.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}

class Pref {
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


  Pref({
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

  factory Pref.fromJson(Map<String, dynamic> parsedJson){
    return Pref(
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

  static List<Pref> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Pref.fromJson(obj))
        .toList()
        .cast<Pref>();
  }


}
