import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/theme/style.dart';

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
  double? height;

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
    this.height,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  _OpinionFloatingActionState createState() => _OpinionFloatingActionState();
}

class _OpinionFloatingActionState extends State<OpinionFloatingAction>  {

  bool isLoading = false;
  bool isActive = false;

  @override
  void initState(){
    this.isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: (){

            if (widget.isActive == false){
              Scaffold.of(context)
                  .showBottomSheet<void>(
                    (context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: (widget.height != null ? widget.height : 430),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            height: 50,
                            child: (widget.title != null)
                                ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.title!,
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                        ),
                                      )
                                : Container(),
                          ),
                          const Divider(thickness: 1),
                          (widget.child != null ? widget.child! : Container()),
                        ],
                      ),
                    ),
                  );
                },
                elevation: 25,
              )
                  .closed
                  .whenComplete(() {
                    setState(() { this.isLoading = false; });
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


              if (this.isLoading == false){
                print("Procesando formulario");
                setState(() { this.isLoading = true; });
                Future.delayed(const Duration(seconds: 2), () => null).then((value){
                  Navigator.pop(context);
                  HopsNotifications notificationClient =  new HopsNotifications();
                  notificationClient.message(context, "¡Comentario publicado!");

                });


              }else{
                // a form submit is being processed, do nothing damn it!
                print("Hold it damn it!");
              }


            }



            if (widget.onTap !=null) widget.onTap!();
          },
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
          label: Text(
              (this.isActive
                  ? widget.textInactive
                  : (this.isLoading == false ? widget.textActive : '')
              ),
              style: TextStyle(color:widget.textColor, ),

          ),
          icon: (this.isLoading == false ? Icon(
            Icons.edit,
            color: widget.textColor,
          ) : Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: SizedBox(height: 10, width: 10, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.0,)),
          ) ) ,
          backgroundColor: widget.bgColor,
        ),
      // Close floating button
      (widget.isActive && this.isLoading == false ?
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
              onPressed: () => (this.isLoading ? null : Navigator.pop(context)),
              backgroundColor: widget.bgColor,
              label: Text("X", style: TextStyle(color: Colors.white))
          ),
        ) : SizedBox(height: 0.01,)),
      ],
    );
  }
}
