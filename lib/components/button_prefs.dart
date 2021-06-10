import 'package:flutter/material.dart';
import 'package:Hops/models/category.dart';
import 'package:Hops/theme/style.dart';

class ButtonPrefs extends StatefulWidget {
  Category category;
  bool isSelected;
  //VoidCallback onSelectPref;
  final Function(Category category) onSelectPref;

  ButtonPrefs(
      this.category,
      {
        Key? key,
        this.isSelected = false,
        required this.onSelectPref,
      }) : super(key: key);

  @override
  _ButtonPrefsState createState() => _ButtonPrefsState();
}

class _ButtonPrefsState extends State<ButtonPrefs> {
  bool _isSelectedNow = false;


  @override
  void initState(){
    super.initState();
    _isSelectedNow = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {

    MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    if (_isSelectedNow) backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));

    Widget buttonChild = Text( widget.category.name!);
    if (_isSelectedNow){
      buttonChild = Wrap(
        spacing: 4.0,
        children: [
          Icon(Icons.check),
          Padding(
            padding: const EdgeInsets.only(top:4),
            child: Text(widget.category.name!),
          )
        ]

      );
    }
    return ElevatedButton(
      onPressed: (){
        setState(() {
          if (_isSelectedNow == true){
            _isSelectedNow = false;
          }else{
            _isSelectedNow = true;
          }

        });
        widget.category.isSelected = _isSelectedNow;
        widget.onSelectPref(widget.category);
      },
      child: buttonChild,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(.6)),
          backgroundColor: backgroundColor,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black.withOpacity(.2)),
              )
          )
      ),
    );
  }
}
