import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:provider/provider.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/order_data.dart';

/// View for adding the frist shipping details for the order
/// this will be later saved as local data and maybe in the database
/// although this is already done via WooCommerce API

class ShippingDetails extends StatefulWidget {
  static const String routeName = "shippingDetails";
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {

  double bottomHeight = 70;
  bool isLoadingApiCall = false;
  late Future<OrderData?> _lastOrderData;
  final _formKey = GlobalKey<FormState>();
  String _dropdownValue = 'Montevideo';
  static const double _horizontalPadding = 30.0;

  @override
  void initState() {
    super.initState();
    _lastOrderData = SharedServices.lastShippingDetails();

  }

  Widget _buildFinishCheckoutButton(){
    // MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));
    return AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      height: bottomHeight,
      padding: EdgeInsets.only( bottom: 5 ),
      decoration: BoxDecoration( gradient: PRIMARY_GRADIENT_COLOR,),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(

              onPressed: (){

                setState(() {
                  bottomHeight = 0;
                  isLoadingApiCall = true;
                });

                if (_formKey.currentState!.validate()) {


                }





              },
              child: Text(
                  "Agregar datos",
                  style: TextStyle(
                      fontSize: 20
                  )
              ),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
                  foregroundColor: MaterialStateProperty
                      .all<Color>(
                      Colors.black.withOpacity(
                          .6)),
                  backgroundColor: backgroundColor,
                  shape: MaterialStateProperty
                      .all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .circular(18.0),
                          side: BorderSide(
                              color: Colors.black
                                  .withOpacity(
                                  .2))
                      )
                  )
              ),
            )
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR
          ),
        ),
        title: Text("Datos de envío"),
        elevation: 0,
      ),
      bottomNavigationBar: _buildFinishCheckoutButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _horizontalPadding,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: _horizontalPadding),
                    child: Text("NOMBRE COMPLETO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 20),
                    child: TextFormField(
                      // initialValue: (_comment != null ? _comment!.comment_content  : null),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu nombre completo.";
                        }
                        if (!RegExp(r'.{5,}').hasMatch(value)) return 'Sé un poco mas específico (al menos 5 letras o números).';
                        if (value.length >= 700) return '¡Wow!, ¿podrías ser mas concret@?.';
                        return null;
                      },
                      // autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        // setState(() { _opinionFormField = value; });
                      },

                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 12.5),

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
                        hintText: 'Ejemplo: Neilo Young.',
                        //labelText: '¿Qué te pareció esta cerveza?',
                        //helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                      ),
                    ),
                  ),


                  SizedBox(height: 15),


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: _horizontalPadding),
                    child: Text("TELÉFONO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 20),
                    child: TextFormField(
                      // initialValue: (_comment != null ? _comment!.comment_content  : null),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu teléfono.";
                        }
                        if (!RegExp(r'.{5,}').hasMatch(value)) return 'Sé un poco mas específico (al menos 5 letras o números).';
                        if (value.length >= 700) return '¡Wow!, ¿podrías ser mas concret@?.';
                        return null;
                      },
                      // autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        // setState(() { _opinionFormField = value; });
                      },

                      keyboardType: TextInputType.phone,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 12.5),

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
                        hintText: 'Mantengámonos en contacto...',
                        //labelText: '¿Qué te pareció esta cerveza?',
                        //helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: _horizontalPadding),
                    child: Text("UBICACIÓN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),



                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 10),
                    child: DropdownButton<String>(
                      value: _dropdownValue,
                      hint:Text("Selecciona una ubicación"),
                      // icon: const Icon(Icons.arrow_downward),
                      iconSize: 25,
                      elevation: 8,
                      style:TextStyle(color:Colors.black87, fontSize: 18),
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconDisabledColor: Colors.red,
                      iconEnabledColor: Colors.black87,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      /*
                      style: const TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),

                       */
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Montevideo', 'Rocha', 'Paysandú']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
                    child: TextFormField(
                      // initialValue: (_comment != null ? _comment!.comment_content  : null),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu dirección 1.";
                        }
                        if (!RegExp(r'.{5,}').hasMatch(value)) return 'Sé un poco mas específico (al menos 5 letras o números).';
                        if (value.length >= 700) return '¡Wow!, ¿podrías ser mas concret@?.';
                        return null;
                      },
                      // autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        // setState(() { _opinionFormField = value; });
                      },

                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 12.5),

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
                        hintText: 'Dirección. Ejemplo: 18 de Julio 1451',
                        //labelText: '¿Qué te pareció esta cerveza?',
                        //helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 10),
                    child: TextFormField(
                      // initialValue: (_comment != null ? _comment!.comment_content  : null),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu complemento de dirección.";
                        }
                        if (!RegExp(r'.{5,}').hasMatch(value)) return 'Sé un poco mas específico (al menos 5 letras o números).';
                        if (value.length >= 700) return '¡Wow!, ¿podrías ser mas concret@?.';
                        return null;
                      },
                      // autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        // setState(() { _opinionFormField = value; });
                      },

                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(fontSize: 12.5),

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
                        hintText: 'Complemento. Ejemplo: Apartamento 425',
                        //labelText: '¿Qué te pareció esta cerveza?',
                        //helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                      ),
                    ),
                  ),

                  SizedBox(height:200)

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
