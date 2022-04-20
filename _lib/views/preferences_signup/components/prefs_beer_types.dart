import 'package:flutter/material.dart';
import 'package:Hops/models/preferences.dart';
import 'package:Hops/components/app_title.dart';
import 'package:Hops/components/button_prefs.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';

import 'package:provider/provider.dart';

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
    //List<Pref> categories = Pref.allFromResponse(widget.json);
    //print(categories);
    //_beerTypeOptions = _buildBeerTypeOptions();
  }

  Widget _buildBeerTypesButtons(){


    var nCategories = _categories;
    List<Widget> list = <Widget>[];
    if (nCategories != null){
      List<Pref> categories = Pref.allFromResponse(nCategories);

      for (var pref in categories) {

        if (pref.id == 15 || pref.id == 163) continue;
        //var categoryName = category.name!;
        list.add(
          Consumer<Preferences>(
            builder: (context, preferences, child){
              bool isSelected = false;
              if (preferences.itemsIds.contains(pref.id.toString())) isSelected = true;
              //if (isSelected == true) print(pref.name);
              return ButtonPrefs(
                  pref,
                  isSelected: isSelected,
                  onSelectPref: (Pref pref) {
                    if(pref.isSelected){
                      preferences.add(pref);
                    }else{
                      preferences.remove(pref);
                    }
                    //setState(() {});
                  }
              );
            },
          )
        );
      }
    }

    return Center(
      child: new Wrap(
        alignment: WrapAlignment.start,
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
        Container(
          padding: EdgeInsets.only(left:20, right:20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: _buildBeerTypesButtons(),
          ),
        ),
      ],
    );
  }
}
