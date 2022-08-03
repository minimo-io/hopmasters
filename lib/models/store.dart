// Store class

class Store {
  String? id;
  String? name;
  String? price;
  String? priceLastUpdate;
  String? url;
  String? image;
  String? isVerified;
  late bool isOfficial;

  Store({
    this.id,
    this.name,
    this.price,
    this.priceLastUpdate,
    this.url,
    this.image,
    this.isVerified,
    this.isOfficial = false,
  });

  Store.fromJson(Map<String, dynamic> parsedJson) {
    id = (parsedJson["id"] ?? "");
    name = (parsedJson["name"] ?? "");
    price = (parsedJson["price"] ?? "");
    priceLastUpdate = (parsedJson["price_last_update"] ?? "");
    url = (parsedJson["url"] ?? "");
    image = (parsedJson["image"] ?? "");
    isVerified = (parsedJson["is_verified"] ?? "");
    isOfficial = (parsedJson["is_official"] == "true" ? true : false);
  }

  static List? allFromResponse(List<dynamic> response) {
    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Store.fromJson(obj))
        .toList()
        .cast<Store>();
  }
}
