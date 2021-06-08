import 'package:flutter/material.dart';
import 'package:Hops/models/category.dart';

class PrefsBeerTypes extends StatefulWidget {
  List<dynamic> json;
  PrefsBeerTypes(this.json, {Key key}) : super(key: key);

  @override
  _PrefsBeerTypesState createState() => _PrefsBeerTypesState();
}

class _PrefsBeerTypesState extends State<PrefsBeerTypes> {
  List<dynamic> _categories;

  @override
  void initState() {
    super.initState();

    _categories = widget.json;
    //List<Category> categories = Category.allFromResponse(widget.json);
    //print(categories);
    //_beerTypeOptions = _buildBeerTypeOptions();
  }

  Widget _buildBeerTypesButtons(){
    List<Category> categories = Category.allFromResponse(_categories);
    List<Widget> list = new List<Widget>();
    for (var category in categories) {
      list.add(
          ElevatedButton(
            child: Text(category.name),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Colors.black)
                    )
                )
            ),
          )

      );
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {

    return Container(child: _buildBeerTypesButtons());
  }
}
