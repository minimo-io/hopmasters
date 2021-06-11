/// Preferences types related to how the user wants to to be contacted
/// or what his or hers interests are: new beers, events, etc.

import 'package:Hops/models/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Hops/components/app_title.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';

import 'package:Hops/components/button_prefs.dart';

class PrefsTypes extends StatefulWidget {
  const PrefsTypes(List<dynamic>json, {Key? key}) : super(key: key);

  @override
  _PrefsTypesState createState() => _PrefsTypesState();
}

class _PrefsTypesState extends State<PrefsTypes> {


  Widget _buildPrefsButtons(){
    List<Widget> list = <Widget>[];
    for (Pref constPref in SINGUP_PREFS.values){
      list.add(
          Consumer<Preferences>(
            builder: (context, preferences, child){
              return ButtonPrefs(
              constPref,
              isSelected: false,
              onSelectPref: (Pref pref) {
                if(pref.isSelected){
                  preferences.addNews(pref);
                }else{
                  preferences.removeNews(pref);
                }
                //setState(() {});
              });
            }
          )
      );
    }
    return Center(
      child: Wrap(
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
        AppTitle(title: "¿Qué te interesa?"),
        SizedBox(height: 5,),
        AppTitle(subtitle: "Elige al menos 1 opción"),
        SizedBox(height: 30,),
        Container(child: _buildPrefsButtons() ),
      ],
    );
  }
}
