import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

class PromosView extends StatefulWidget {
  static const String routeName = "promos";
  const PromosView({Key? key}) : super(key: key);

  @override
  State<PromosView> createState() => _PromosViewState();
}

class _PromosViewState extends State<PromosView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: ()async{
          setState(() {
            // _userData = SharedServices.loginDetails();
          });

        },
        child: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  Image.asset("assets/images/loudly-crying-face_1f62d.png", height: 45,),
                  SizedBox(height: 10,),
                  Center(child: RichText(
                    text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "En construcción.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))
                        ]
                    ),
                  ),),
                  SizedBox(height: 10,),
                  Center(child: RichText(
                    text: TextSpan(text: "Mientras tanto puedes descubrir ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                  ),),
                  Center(child: RichText(
                    text: TextSpan(text: "nuevas experiencias en ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                  ),),
                  Center(child: RichText(
                    text: TextSpan(text: "hops.uy", style: TextStyle(fontSize: 20, color: Colors.black87)),
                  ),),

                  SizedBox(height: 10,),

                  /*
                  ElevatedButton(
                    onPressed: (){

                      Helpers.launchURL("https://hops.uy/revista/turismo/");

                    },

                    child: Wrap(
                        spacing: 4.0,
                        children: [
                          Icon(Icons.sports_bar),
                          Padding(
                            padding: const EdgeInsets.only(top:4),
                            child: Text("Descubrir ahora"),
                          )
                        ]

                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(.6)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black.withOpacity(.2)),
                            )
                        )
                    ),
                  ),

                   */
                  SizedBox(height: 600,),
                ],
              ),)
          ),
        ),
      ),
    );
  }
}
