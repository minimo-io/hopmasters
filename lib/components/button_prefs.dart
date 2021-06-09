import 'package:flutter/material.dart';
import 'package:Hops/models/category.dart';
import 'package:Hops/theme/style.dart';

class ButtonPrefs extends StatefulWidget {
  Category category;
  bool isSelected;
  VoidCallback onSelectPref;
  //ValueChanged<Category> onSelectPref;

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
  @override
  Widget build(BuildContext context) {

    MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    if (widget.isSelected) backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));

    Widget buttonChild = Text( widget.category.name!);
    if (widget.isSelected){
      buttonChild = Wrap(
        spacing: 4.0,
        children: [
          Icon(Icons.check),
          SizedBox(width: 1,),
          Padding(
            padding: const EdgeInsets.only(top:4),
            child: Text(widget.category.name!),
          )
        ]

      );
    }
    return ElevatedButton(
      onPressed: (){
        widget.onSelectPref();
      },
      child: buttonChild,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(.6)),
          backgroundColor: backgroundColor,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black.withOpacity(.2))
              )
          )
      ),
    );
  }
}
