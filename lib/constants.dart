import 'package:Hops/models/preferences.dart';

const APP_TITLE = "HOPS";

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

enum HopsMenuState { home, favourite, store, profile }

Map<String, Pref> SINGUP_PREFS = {
  'newBeers': Pref(
      count: 0,
      description: '',
      name: "Nuevas cervezas",
      display: '',
      id: 666661,
      image: '',
      menu_order: 0,
      parent:0,
      slug: ''
  ),
  'news' : Pref(
      count: 0,
      description: '',
      name: "Notícias",
      display: '',
      id: 666662,
      image: '',
      menu_order: 0,
      parent:0,
      slug: ''
  ),
  'discounts': Pref(
      count: 0,
      description: '',
      name: "Descuentos",
      display: '',
      id: 666663,
      image: '',
      menu_order: 0,
      parent:0,
      slug: ''
  ),
  'events': Pref(
      count: 0,
      description: '',
      name: "Eventos",
      display: '',
      id: 666664,
      image: '',
      menu_order: 0,
      parent:0,
      slug: ''
  )
};

/*
const String WP_BASE_API = "https://hops.uy";
const String WP_REST_VERSION_URI = "/wp-json/wp/v2/";
const String WP_REST_WC_VERSION_URI = "/wp-json/wc/v3/"; // for WooCommerce
const String WP_REST_HOPS_VERSION_URI = "/wp-json/hops/v1/"; // custom endpoint for WooCommerce
*/
