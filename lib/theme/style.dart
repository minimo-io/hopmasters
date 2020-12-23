import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme.light(
  primary: Color.fromRGBO(252, 215, 52, 1),
  primaryVariant: Color.fromRGBO(255, 255, 107, 1),
  secondary: Color.fromRGBO(176, 190, 197, 1),
  secondaryVariant: Color.fromRGBO(226, 241, 248, 1),
  background: Color.fromRGBO(252, 252, 252, 1)
);

ThemeData hopmastersTheme() {
  return ThemeData.from(
    colorScheme: colorScheme
  );
}

