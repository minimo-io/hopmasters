import 'package:flutter/material.dart';

/**
 * This is for advanced beer filters, like the ones available in the "Discover" section
 */
class AdvacedBeerFilter{

  AdvacedBeerFilter({
    this.apiEndpoint = "ibu",
    this.extraParam,
    this.icon = Icons.circle,
    this.iconColor = Colors.amber,
    this.name = "",
    this.alert,
  });

  String apiEndpoint;
  String? extraParam;
  IconData icon;
  Color iconColor;
  String name;
  String? alert;
}