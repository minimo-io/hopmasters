import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_page/search_page.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/home/bannerBreweries.dart';
import 'package:hopmasters/components/home/specialOffers.dart';
import 'package:hopmasters/components/beer.dart';
import 'package:hopmasters/services/wordpress.dart';


/// This is a very simple class, used to
/// demo the `SearchPage` package
class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}

class homeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<homeView> {
  // homeView({Key key}) : super(key: key);

  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];
  /*
  static List<Beer> beers = [
    Beer(
      image: dimmyBeerImagePath,
      type: 'IPA',
      name: 'Maracuyipa',
      price: 250,
    ),
    Beer(
      image: dimmyBeerImagePath,
      type: 'APA',
      name: 'Cruda Realidad',
      price: 280,
    ),
    Beer(
      image: dimmyBeerImagePath,
      type: 'Kolsch',
      name: 'Dortmunder',
      price: 150,
    ),
  ];
  */
  static List<Beer> beers = [];


  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        "Nicolas",
      ),
      accountEmail: Text(
        "nicolas@minimo.io",
      ),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );

    Widget _buildBeerBox(BuildContext context) {
      Widget _buildBottomItem(Beer beer) => Card(
        elevation: 4,
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 8),
                        child: Icon(Icons.favorite_border),
                      )),
                  Expanded(
                    child: Image.asset(beer.image),
                  ),
                  Container(child: Padding(padding: EdgeInsets.only(top:10.0)),),
                  Text(
                    beer.name,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "\$${beer.price}",
                    style: TextStyle(fontSize: 11),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 4),
                  child: Text(
                    'NUEVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                color: Colors.pinkAccent.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );

      const beersBottom = [
        const Beer(
            name: 'Maracuyipa',
            type: "IPA",
            abv: 8,
            price: 170.00,
            image: dimmyBeerImagePath),
        const Beer(
            name: 'NIKE AIR FORCE',
            type: "APA",
            abv: 6,
            price: 130.00,
            image: dimmyBeerImagePath)
      ];

      return Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.29,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: marginSide),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBottomItem(beersBottom.first),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildBottomItem(beersBottom.last),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildHeader() {
      return Padding(
        /*padding: const EdgeInsets.only(top: 8.0),*/
        padding:const EdgeInsets.symmetric(
        horizontal: 15.0, vertical: 0.0),
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Descubrir',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: beerStyles.length,
            itemBuilder: (_, index) => Padding(
              padding: index == 0
                  ? const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4)
                  : const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 4),
              child: Text(
                beerStyles[index],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: index == 0 ? colorScheme.secondary : colorScheme.secondary.withOpacity(0.5)  ,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ],
        ),
      );
    }

    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: SECONDARY_BUTTON_COLOR,
          foregroundColor: Colors.white,
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Person>(
              onQueryUpdate: (s) => print(s),
              items: people,
              searchLabel: 'Buscar...',
              suggestion: Center(
                child: Text('¡Encuentra cervezas y cervecerías!'),
              ),
              failure: Center(
                child: Text('Ups! No encontramos nada :('),
              ),
              filter: (person) => [
                person.name,
                person.surname,
                person.age.toString(),
              ],
              builder: (person) => ListTile(
                title: Text(person.name),
                subtitle: Text(person.surname),
                trailing: Text('${person.age} yo'),
              ),
            ),
          ),
          child: Icon(Icons.search),
        ),
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR
            ),
          ),
          iconTheme: IconThemeData(
              color: colorScheme.secondary
          ),
          /*
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(child: Text("HOPMASTERS", style: TextStyle(color:Colors.white))),
          ),
          */
          title: Padding(
            padding: const EdgeInsets.fromLTRB(15, 28.0, 0, 8.0),
            child: Container(child: Text("HOPMASTERS", style: GoogleFonts.russoOne(
                textStyle: TextStyle(color: colorScheme.secondary)
            ))),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Carrito',
                onPressed: () {

                  Navigator.pushNamed(context, '/cart');

                  topBeers();
                },
              ),
            ),
            Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 18.0, 6.0, 0),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      tooltip: 'Notificaciones',
                      onPressed: () {
                          print("OHH BOY MENU");
                      },
                   ),
                  ),
                  Positioned(
                    right:15,
                    top:20,
                    child: Container(
                      height: 18,
                      width:18,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.white)
                      ),
                      child: Center(child: Text("4", style: TextStyle(fontSize: 11, height: 1, color: Colors.white, fontWeight: FontWeight.w600)))
                    ),
                  )
                ]
            )
          ],
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child:NavBottom()
        ),
        body:SafeArea(
          
          child: Container(
              decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child:Column(
                  children: [
                Container(child: BreweriesBanner()),
                SpecialOffers(),
                Padding(
                  padding: const EdgeInsets.all(marginSide),
                  child: _buildHeader(),
                ),
                Expanded(child: _buildBeerBox(context)),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.count(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 2 : 3,
                          childAspectRatio:
                              (orientation == Orientation.portrait) ? 1.0 : 1.3,
                          children: beers.map<Widget>((Beer beer) {
                            return new BeerGridTile(
                                name: beer.name,
                                type: beer.type,
                                image: beer.image,
                                price: beer.price);
                          }).toList(),
                        )))
              ]
          )),
        ));
  }
}

// class homeView extends StatelessWidget{

// }
