import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';

class OpinionFloatingAction extends StatefulWidget {
  String textInactive;
  String textActive;
  Color? bgColor = Colors.black54;
  Color? textColor = Colors.white;
  Null Function()? onTap;
  Null Function()? onClose;
  Widget? child;
  String? title;
  bool isActive;

  OpinionFloatingAction(
    this.textInactive,
    this.textActive,
    {
    this.textColor,
    this.bgColor,
    this.onTap,
    this.onClose,
    this.child,
    this.title,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  _OpinionFloatingActionState createState() => _OpinionFloatingActionState();
}

class _OpinionFloatingActionState extends State<OpinionFloatingAction> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: (){

        if (widget.isActive == false){
          Scaffold.of(context)
              .showBottomSheet<void>(
                (context) {
              return Container(
                height: 430,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      height: 50,
                      child: (widget.title != null) ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                      ) : Container(),
                    ),
                    const Divider(thickness: 1),
                    (widget.child != null ? widget.child! : Container()),
                  ],
                ),
              );
            },
            elevation: 25,
          )
              .closed
              .whenComplete(() {

                if (widget.onClose !=null) widget.onClose!();
            /*
          if (mounted) {
            setState(() {
              // Re-enable the bottom sheet button.
              _showBottomSheetCallback = _showPersistentBottomSheet;
            });
          }
          */
          });
        }else{

          Navigator.pop(context);

        }



        if (widget.onTap !=null) widget.onTap!();
      },
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
      label: Text(
          (widget.isActive ? widget.textInactive : widget.textActive),
          style: TextStyle(color:widget.textColor, ),

      ),
      icon: Icon(Icons.edit, color: widget.textColor,),
      backgroundColor: widget.bgColor,
    );
  }
}
