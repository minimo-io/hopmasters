import 'package:flutter/material.dart';
import 'package:Hops/models/category.dart';
import 'package:Hops/components/app_title.dart';
import 'package:Hops/components/button_prefs.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';

class PrefsBeerTypes extends StatefulWidget {
  List<dynamic>? json;
  PrefsBeerTypes(this.json, {Key? key}) : super(key: key);

  @override
  _PrefsBeerTypesState createState() => _PrefsBeerTypesState();
}

class _PrefsBeerTypesState extends State<PrefsBeerTypes> {
  List<dynamic>? _categories;

  @override
  void initState() {
    super.initState();

    _categories = widget.json;
    //List<Category> categories = Category.allFromResponse(widget.json);
    //print(categories);
    //_beerTypeOptions = _buildBeerTypeOptions();
  }

  Widget _buildBeerTypesButtons(){


    var nCategories = _categories;
    List<Widget> list = <Widget>[];
    if (nCategories != null){
      List<Category> categories = Category.allFromResponse(nCategories);

      for (var category in categories) {

        if (category.id == 15 || category.id == 163) continue;
        //var categoryName = category.name!;
        list.add(
          ButtonPrefs(
            category,
            isSelected: false,
            onSelectPref: (Category category) {
              print(category.name! + "... Updated!");
              //setState(() {});
            }
          )
        );
      }
    }

    return Center(
      child: new Wrap(
          //runSpacing: 5.0,
          spacing: 5.0,
          children: list
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle(title: "¿Qué estilos preferís?"),
        SizedBox(height: 5,),
        AppTitle(subtitle: "Elige al menos 5 opciones"),
        SizedBox(height: 30,),
        Container(child: _buildBeerTypesButtons()),
      ],
    );
  }
}
