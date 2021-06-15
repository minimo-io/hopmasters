import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

/*
final ColorScheme colorScheme = ColorScheme.light(
  primary: Color.fromRGBO(252, 215, 52, 1),
  primaryVariant: Color.fromRGBO(255, 255, 107, 1),
  secondary: Color.fromRGBO(52, 73, 85, 1),
  secondaryVariant: Color.fromRGBO(95, 116, 129, 1),
  background: Color.fromRGBO(252, 252, 255, 1),
);
*/

final ColorScheme colorScheme = ColorScheme.light(
  primary: Color.fromRGBO(255, 255, 255, 1),
  secondary: Color.fromRGBO(27, 29, 31, 1),
  primaryVariant: Color.fromRGBO(255, 255, 107, 1),
  secondaryVariant: Color.fromRGBO(95, 116, 129, 1),
  background: Colors.grey[400]!,
);

const Color PRIMARY_BUTTON_COLOR = Color.fromRGBO(0, 223, 106, 1);
const Color PRIMARY_BUTTON_DARK = Color.fromRGBO(67, 203, 130, 1);
const Color SECONDARY_BUTTON_COLOR = Color.fromRGBO(255, 212, 53, 0.8);

const Color SECONDARY_TEXT_DARK = Color.fromRGBO(48, 49, 51, 1);

const Color ACTION_BUTTON_PRIMARY_COLOR = Color.fromRGBO(234,240,76, 1); // login eg.

const Color PROGRESS_INDICATOR_COLOR = Colors.black54; // login eg.


const PRIMARY_GRADIENT_COLOR = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  stops: [0.1, 0.5, 0.7, 0.9],
  colors: [
    Color.fromRGBO(236, 236, 236, 1),
    Color.fromRGBO(243, 243, 243, 1),
    Color.fromRGBO(249, 249, 249, 1),
    Color.fromRGBO(255, 255, 255, 1),
  ],
);

const SECONDARY_GRADIENT_COLOR = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  stops: [0.1, 0.5, 0.7, 0.9],
  colors: [
    Color.fromRGBO(216, 170, 0, 0.6),
    Color.fromRGBO(234, 186, 0, 0.6),
    Color.fromRGBO(250, 205, 0, 0.6),
    Color.fromRGBO(255, 212, 53, 0.6),
  ],
);

/*final TextTheme textTheme  = TextTheme(
headline1: GoogleFonts.roboto(
fontSize: 96,
fontWeight: FontWeight.w300,
letterSpacing: -1.5
),
headline2: GoogleFonts.roboto(
fontSize: 60,
fontWeight: FontWeight.w300,
letterSpacing: -0.5
),
headline3: GoogleFonts.roboto(
fontSize: 48,
fontWeight: FontWeight.w400
),
headline4: GoogleFonts.roboto(
fontSize: 34,
fontWeight: FontWeight.w400,
letterSpacing: 0.25
),
headline5: GoogleFonts.roboto(
fontSize: 24,
fontWeight: FontWeight.w400
),
headline6: GoogleFonts.roboto(
fontSize: 20,
fontWeight: FontWeight.w500,
letterSpacing: 0.15
),
subtitle1: GoogleFonts.roboto(
fontSize: 16,
fontWeight: FontWeight.w400,
letterSpacing: 0.15
),
subtitle2: GoogleFonts.roboto(
fontSize: 14,
fontWeight: FontWeight.w500,
letterSpacing: 0.1
),
bodyText1: GoogleFonts.roboto(
fontSize: 16,
fontWeight: FontWeight.w400,
letterSpacing: 0.5
),
bodyText2: GoogleFonts.roboto(
fontSize: 14,
fontWeight: FontWeight.w400,
letterSpacing: 0.25
),
button: GoogleFonts.roboto(
fontSize: 14,
fontWeight: FontWeight.w500,
letterSpacing: 1.25
),
caption: GoogleFonts.roboto(
fontSize: 12,
fontWeight: FontWeight.w400,
letterSpacing: 0.4
),
overline: GoogleFonts.roboto(
fontSize: 10,
fontWeight: FontWeight.w400,
letterSpacing: 1.5
),
);*/

ThemeData hopmastersTheme() {
  return ThemeData.from(
    colorScheme: colorScheme,
    // textTheme: textTheme
  );
}
