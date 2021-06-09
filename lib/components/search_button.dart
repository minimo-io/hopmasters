import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:Hops/theme/style.dart';

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}


final List<Person> people = [
  Person('Mike', 'Barron', 64),
  Person('Todd', 'Black', 30),
  Person('Ahmad', 'Edwards', 55),
  Person('Anthony', 'Johnson', 67),
  Person('Annette', 'Brooks', 39),
  Person('Nicolas', 'Erramuspe', 39),
];

class SearchButton extends StatefulWidget {
  const SearchButton({ Key? key }) : super(key: key);

  @override
  _hmSearchButtonState createState() => _hmSearchButtonState();
}

class _hmSearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {



    return FloatingActionButton(
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
    );


  }
}