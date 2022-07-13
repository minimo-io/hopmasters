class OrderData {
  String? customerId;
  String? firstName;
  String? lastName;
  String? telephone;
  String? email;
  String? paymentType = "cod";
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country = "UY";
  String? postCode = "0";
  List? beersList;
  String? shippingMethodId = "flat_rate";
  String? shippingRate;
  String? status = "processing";

  String customerNote = "";

  String paymentTypeTitle = "Contra reembolso";

  OrderData({
    this.customerId,
    this.customerNote = "",
    this.firstName,
    this.lastName,
    this.telephone,
    this.email,
    this.paymentType,
    this.paymentTypeTitle = "Contra reembolso",
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.postCode,
    this.beersList,
    this.shippingMethodId,
    this.shippingRate,
    this.status,
  });

  Map<String, dynamic> toJson() {
    //OrderData.toJson(){
    Map<String, dynamic> map = {};
    map.addAll({
      "customer_id": customerId,
      "customer_note": customerNote,
      "payment_method": paymentType,
      "payment_method_title": paymentTypeTitle,
      "set_paid": false,
      "status": status,
      "billing": {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "state": state,
        "postcode": postCode,
        "country": country,
        "email": email,
        "phone": telephone
      },
      "shipping": {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "state": state, // CA
        "postcode": postCode,
        "country": country
      },
      "line_items": beersList,
      "shipping_lines": [
        {
          "method_id": shippingMethodId,
          "method_title": "Costo de envío",
          "total": shippingRate.toString()
        }
      ]
    });
    return map;
  }

  OrderData.fromJson(Map<String, dynamic> json) {
    customerId = json["customer_id"];
    customerNote = json["customer_note"] ?? "";
    firstName = json["billing"]["first_name"];
    lastName = json["billing"]["last_name"];
    telephone = json["billing"]["phone"];
    email = json["billing"]["email"];
    paymentType = json["payment_method"];
    paymentTypeTitle = json["payment_method_title"];
    address1 = json["billing"]["address_1"];
    address2 = json["billing"]["address_2"];
    city = json["billing"]["city"];
    state = json["billing"]["state"];
    country = json["billing"]["country"];
    postCode = json["billing"]["postcode"];
    beersList = json[
        "beersList"]; //beerList = json["data"].length > 0 ? new Data.fromJson(json["data"]) : null;
    shippingMethodId = json["shipping_lines"][0]["method_id"];
    shippingRate = json["shipping_lines"][0]["total"];
    status = json["status"];
  }
}
