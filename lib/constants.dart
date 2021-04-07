import 'package:flutter/material.dart';

const APP_TITLE = "HOPS / UY";

// Only put constants shared between files here.

// height of the 'Gallery' header
const double galleryHeaderHeight = 64;

// The font size delta for headline4 font.
const double desktopDisplay1FontDelta = 16;

// The width of the settingsDesktop.
const double desktopSettingsWidth = 520;

// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

// The splash page animation duration.
const splashPageAnimationDurationInMilliseconds = 300;

// The desktop top padding for a page's first header (e.g. Gallery, Settings)
const firstHeaderDesktopTopPadding = 5.0;


const marginSide = 18.0;


const beerStyles = ['Todas', 'IPA', 'Blonde', 'APA', 'Kölsch', 'Red'];

const dummyBeerImagePath = "assets/images/avante-supernauta.jpg";
const dummyBeerImagePath2 = "assets/images/mastra-app.jpg";

enum HopsMenuState { home, favourite, store, profile }

const String WP_BASE_API = "https://hopmasters.net";
const String WP_REST_VERSION_URI = "/wp-json/wp/v2/";