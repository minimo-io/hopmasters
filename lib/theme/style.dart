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
  /*primary: Color.fromRGBO(255, 255, 255, 1),*/
    primary: Color.fromRGBO(67, 203, 131, 1),
  primaryVariant: Color.fromRGBO(255, 255, 107, 1),
  secondary: Color.fromRGBO(27, 29, 31, 1),
  secondaryVariant: Color.fromRGBO(95, 116, 129, 1),
  background: Colors.yellow[800],
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
