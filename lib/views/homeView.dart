import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:hopmasters/theme/style.dart';
import 'package:hopmasters/constants.dart';
import 'package:hopmasters/components/nav_bottom.dart';
import 'package:hopmasters/components/beer.dart';

const brands = ['Todas', 'IPA', 'Blonde', 'APA', 'Kölsch', 'Red'];
const dimmyBeerImagePath = "assets/images/beer.jpg";

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
                    color: Colors.pinkAccent,
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
        color: colorScheme.background,
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
        padding: const EdgeInsets.only(top: 8.0),
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
                    color: Colors.black,
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
                itemCount: brands.length,
                itemBuilder: (_, index) => Padding(
                  padding: index == 0
                      ? const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4)
                      : const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4),
                  child: Text(
                    brands[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: index == 0 ? Colors.black : Colors.grey[400],
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
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.black,
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Person>(
              onQueryUpdate: (s) => print(s),
              items: people,
              searchLabel: 'Buscar...',
              suggestion: Center(
                child: Text('¡Encuentra cervezas, cervecerías y locales!'),
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
          title: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Text("Hopmasters")),
          )),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Carrito',
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            drawerHeader,
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensajes'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Blog'),
            ),
          ],
        )),
        bottomNavigationBar: new NavBottom(),
        body: Column(children: [
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
                      return  new BeerGridTile( name: beer.name, type: beer.type, image: beer.image, price: beer.price );
                    }).toList(),
                  )))
        ]));
  }
}

// class homeView extends StatelessWidget{

// }
