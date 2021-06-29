import 'package:flutter/material.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'dart:ui';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/theme/style.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:Hops/utils/notifications.dart';
import 'package:Hops/models/login.dart';
import 'package:Hops/models/comment.dart';

class OpinionFloatingAction extends StatefulWidget {
  String textInactive;
  String textActive;
  Color? bgColor = Colors.black54;
  Color? textColor = Colors.white;
  Null Function()? onTap;
  Null Function()? onClose;
  dynamic Function(int a, double b)? updateParentScore;
  Widget? child;
  String? title;
  bool isActive;
  double? height;
  LoginResponse? userData;
  int postId;
  Comment? comment;
  String? commentText; // inviting to vote, varies if beer or brewery.

  OpinionFloatingAction(
      this.textInactive,
      this.textActive,
      {
        this.textColor,
        this.bgColor,
        this.onTap,
        this.onClose,
        this.updateParentScore,
        this.child,
        this.title,
        this.height,
        this.userData,
        this.postId = 0,
        this.comment,
        this.isActive = false,
        this.commentText = "Contanos qué te pareció esta cerveza y qué puntaje le dejarías.",
        Key? key,
      }) : super(key: key);

  @override
  _OpinionFloatingActionState createState() => _OpinionFloatingActionState();
}

class _OpinionFloatingActionState extends State<OpinionFloatingAction>  {

  bool isLoading = false;
  late bool isActive;
  final _formKey = GlobalKey<FormState>();
  late double _rating = 3.0;
  bool formValidatedOnce = false;
  String? _opinionFormField = "";
  Comment? _comment;

  @override
  void initState(){
    this.isActive = widget.isActive;
    _comment = widget.comment;
    _rating = (_comment != null && _comment!.rating != null ? double.parse(_comment!.rating!) : 3.0);

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

                          // old child
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 0,),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(widget.commentText!, style: TextStyle(fontSize: 15)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RatingBar.builder(
                                    initialRating: _rating,
                                    glow:true,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    unratedColor: Colors.amber.withAlpha(85),
                                    itemCount: 5,
                                    itemSize: 35.0,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                      });
                                    },
                                    updateOnDrag: true,
                                  ),
                                ),
                                SizedBox(height: 0,),
                                //Text("Un comentario", style: TextStyle(fontSize: 18)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                                  child: TextFormField(
                                    initialValue: (_comment != null ? _comment!.comment_content  : null),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Ingresa un comentario.";
                                      }
                                      if (!RegExp(r'.{10,}').hasMatch(value)) return 'Sé un poco mas específico (al menos 10 letras o números).';
                                      if (value.length >= 700) return '¡Wow!, ¿podrías ser mas concret@?.';
                                      return null;
                                    },
                                    autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                                    onSaved: (String? value) {
                                      // This optional block of code can be used to run
                                      // code when the user saves the form.
                                      setState(() { _opinionFormField = value; });
                                    },

                                    keyboardType: TextInputType.multiline,
                                    textAlignVertical: TextAlignVertical.top,
                                    style: TextStyle(fontSize: 12.5),

                                    maxLines: 3,
                                    minLines: 1,


                                    //style: TextStyle( fontSize: 13 ),

                                    decoration: new InputDecoration(
                                      labelStyle: TextStyle( color: colorScheme.secondary, fontSize: 12.5, fontWeight: FontWeight.normal ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: colorScheme.secondary, width: 1),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: new BorderSide(color: colorScheme.secondary)),
                                      hintText: 'Contanos...',
                                      labelText: '¿Qué te pareció esta cerveza?',
                                      helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

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

                setState(() { this.isLoading = true; });
                setState(() { this.formValidatedOnce = true; });

                if (_formKey.currentState!.validate()) {
                  // print("Rating");
                  // print(_rating);
                  //FocusScope.of(context).requestFocus(new FocusNode()); // close keyboard
                  FocusManager.instance.primaryFocus?.unfocus();
                  _formKey.currentState!.save();

                  int userId = (widget.userData!.data!.id != null ? widget.userData!.data!.id! : 0);

                  WordpressAPI.addEditComment(
                    userId,
                    widget.postId,
                    _opinionFormField,
                    rating: _rating,
                    commentId: (_comment != null ? _comment!.comment_ID  : null)

                  ).then((result){
                    HopsNotifications notificationClient =  new HopsNotifications();
                    setState(() { this.isLoading = false; });
                    setState(() { this.formValidatedOnce = false; });
                    if (result["result"] == true){
                      // update parent score state
                      double opinionScore = 0.0;
                      if (result["opinionScore"] is int){
                        opinionScore = result["opinionScore"].toDouble();
                      }else{
                        opinionScore = result["opinionScore"];
                      }

                      if ( widget.updateParentScore != null) widget.updateParentScore!(result["opinionCount"], opinionScore);
                      // close opinion box
                      Navigator.pop(context);
                      if (_comment != null){
                        notificationClient.message(context, WordpressAPI.MESSAGE_OK_EDITCOMMENT);
                      }else{
                        notificationClient.message(context, WordpressAPI.MESSAGE_OK_ADDCOMMENT);
                      }

                      // update parent & this widgets comment in memory using this data
                      _comment = Comment.fromJson(result["data"]);


                    }else{
                      notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_ADDEDITCOMMENT + " / " + result["data"]);

                    }


                  });


                }else{

                  setState(() { this.isLoading = false; });


                }




              }else{
                // a form submit is being processed, do nothing damn it!
                //print("Hold it damn it!");
              }


            }



            if (widget.onTap !=null) widget.onTap!();
          },

          shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
          label: Text(
            (widget.isActive
                ? (
                    this.isLoading == false
                      ? (_comment != null ? "MODIFICAR" : widget.textInactive)
                      : ''
                  )
                :  (_comment != null ? "MODIFICAR OPINIÓN" : widget.textActive)
            ),
            style: TextStyle(color:widget.textColor, fontSize:12),

          ),
          icon: (this.isLoading == false ? Icon(
            Icons.edit,
            size:18,
            color: widget.textColor,
          ) : Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: SizedBox(height: 10, width: 10, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.0,)),
          ) ) ,
          backgroundColor: (this.isLoading == false ? widget.bgColor : Colors.grey),
        )
        ,

        // ADD / PUBLISH BUTTON


        // Close floating button
        (widget.isActive && this.isLoading == false ?
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(15)) ),
              onPressed: () => (this.isLoading ? null : Navigator.pop(context)),
              backgroundColor: widget.bgColor,
              label: Text("X", style: TextStyle(color: Colors.white, fontSize: 12))
          ),
        ) : SizedBox(height: 0.01,)),
      ],
    );
  }
}