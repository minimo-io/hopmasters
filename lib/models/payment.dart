import 'package:flutter/material.dart';

/// Payment gateway from Woocommerce API

class Payment {
  Payment(
      {required this.id,
      required this.icon,
      required this.title,
      required this.description,
      required this.enabled});

  String id, title, description;
  bool enabled;
  IconData icon;

  factory Payment.fromJson(Map<String, dynamic> parsedJson) {
    IconData icon = Icons.payment;
    if (parsedJson["id"] == "bacs") icon = Icons.account_balance;
    if (parsedJson["id"] == "cod") icon = Icons.handshake;

    if (parsedJson["id"] == "blockonomics") icon = Icons.currency_bitcoin;

    if (parsedJson["id"] == "paypal" || parsedJson["id"] == "ppcp-gateway") {
      icon = Icons.paypal;
    }
    if (parsedJson["id"] == "woo-mercado-pago-basic" ||
        parsedJson["id"] == "woo-mercado-pago-custom" ||
        parsedJson["id"] == "woo-mercado-pago-ticket") icon = Icons.credit_card;

    return Payment(
        id: parsedJson["id"],
        icon: icon,
        title: parsedJson["title"],
        description: parsedJson["description"],
        enabled: parsedJson["enabled"]);
  }

  static List<Payment> allFromResponse(List<dynamic> response) {
    //var decodedJson = response.cast<String, dynamic>();

    return response
        .cast<Map<String, dynamic>>()
        .map((obj) => Payment.fromJson(obj))
        .toList()
        .cast<Payment>();
  }
}
