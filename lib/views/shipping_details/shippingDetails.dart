import 'package:Hops/components/hops_alert.dart';
import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:provider/provider.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/models/order_data.dart';

/// View for adding the first shipping details for the order
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
  static const double _horizontalPadding = 25.0;
  bool formValidatedOnce = false;

  double _phoneBottomPadding = 10.0;

  // form field
  String? _frmFullName = "";
  String? _frmTelephone = "";
  String? _frmAddress1 = "";
  String? _frmAddress2 = "";
  String? _frmLocation = "";
  String? _frmCP = "11200"; // ideally we will never ask for this

  @override
  void initState() {
    super.initState();
    _lastOrderData = SharedServices.lastShippingDetails();

    //SharedServices.removeLastShippingDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lastOrderData.then((value) {
        _dropdownValue = value!.state!;
      });
    });
  }

  Widget _buildFinishCheckoutButton() {
    // MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    MaterialStateProperty<Color?>? backgroundColor =
        MaterialStateProperty.all<Color>(
            SECONDARY_BUTTON_COLOR.withOpacity(.65));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: bottomHeight,
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        gradient: PRIMARY_GRADIENT_COLOR,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  bottomHeight = 0;
                  isLoadingApiCall = true;
                });

                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _formKey.currentState!.save();

                  List<String> fullname = _frmFullName!.split(" ");

                  // get last shipping details from stored shared services
                  OrderData newOrder = OrderData(
                      customerId: "0",
                      firstName: fullname[0],
                      lastName: fullname[1],
                      telephone: _frmTelephone,
                      email: "",
                      paymentType: "cod", // cash on delivery
                      address1: _frmAddress1,
                      address2: _frmAddress2,
                      city: _frmLocation,
                      state: _dropdownValue,
                      country: "UY",
                      postCode: _frmCP,
                      beersList: [],
                      shippingMethodId: "flat_rate",
                      shippingRate: "0.0");

                  SharedServices.setLastShippingDetails(newOrder).then((value) {
                    // var notificationClient = new HopsNotifications();
                    // notificationClient.message(
                    //     context, "Datos guardados ¡Gracias!");
                    // llamar al callback del parent
                    Navigator.of(context).pop();
                  });
                } else {
                  setState(() {
                    bottomHeight = 70;
                    isLoadingApiCall = false;
                    formValidatedOnce = true;
                  });
                }
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 25.0)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black.withOpacity(1)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(77, 159, 0, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              color: Color.fromRGBO(77, 159, 0, 1))))),
              child: const Text("Agregar datos",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            )),
      ),
    );
  }

  Widget _createShippingInputField() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        title:
            const Text("Datos de envío", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      bottomNavigationBar: _buildFinishCheckoutButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
              child: FutureBuilder(
                  future: _lastOrderData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: PROGRESS_INDICATOR_COLOR,
                              strokeWidth: 1,
                            ));
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: _horizontalPadding),
                                    child: HopsAlert(
                                      text:
                                          "Te los pediremos una sola vez pero lo podrás cambiar en cada pedido.",
                                      icon: Icons.info,
                                      color: Colors.blue,
                                    )),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: _horizontalPadding,
                                      right: _horizontalPadding,
                                      bottom: 0,
                                      top: 5.0),
                                  child: Row(
                                    children: const [
                                      Text("¿Quién lo recibe?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 1),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                          top: 0,
                                          left: 5.0,
                                          right: 5.0),
                                      child: TextFormField(
                                        initialValue: (snapshot.data != null
                                            ? snapshot.data.firstName +
                                                " " +
                                                snapshot.data.lastName
                                            : null),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Ingresa tu nombre completo.";
                                          }
                                          if (!RegExp(r'.{5,}').hasMatch(value))
                                            return 'Sé un poco mas específico (al menos 5 letras o números).';
                                          List<String> twoValues =
                                              value.split(" ");
                                          if (twoValues.length < 2)
                                            return "Ingresa tu nombre y apellido separados de un espacio.";
                                          if (value.length >= 700)
                                            return '¡Wow!, ¿podrías ser mas concret@?.';
                                          return null;
                                        },
                                        autovalidateMode:
                                            (this.formValidatedOnce == true
                                                ? AutovalidateMode.always
                                                : AutovalidateMode
                                                    .onUserInteraction),

                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                          setState(() {
                                            _frmFullName = value;
                                          });
                                        },

                                        keyboardType: TextInputType.name,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        style: const TextStyle(fontSize: 12.5),

                                        //style: TextStyle( fontSize: 13 ),
                                        maxLength: 30,
                                        decoration: const InputDecoration(
                                          hintText: 'Ej: Ruben Rada.',
                                          border: InputBorder.none,
                                          helperStyle:
                                              TextStyle(fontSize: 10.0),
                                          labelText: 'Nombre completo',
                                          //hintText: "Nota para el envío",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 8.0),
                                          errorStyle: TextStyle(fontSize: 10.0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 0),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: _phoneBottomPadding,
                                          top: 0,
                                          left: 5.0,
                                          right: 5.0),
                                      child: TextFormField(
                                        initialValue: (snapshot.data != null
                                            ? snapshot.data.telephone
                                            : null),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Ingresa tu teléfono.";
                                          }
                                          if (!RegExp(r'.{5,}')
                                              .hasMatch(value)) {
                                            return 'Sé un poco mas específico (al menos 5 letras o números).';
                                          }

                                          if (value.length >= 700)
                                            return '¡Wow!, ¿podrías ser mas concret@?.';
                                          return null;
                                        },
                                        autovalidateMode:
                                            (this.formValidatedOnce == true
                                                ? AutovalidateMode.always
                                                : AutovalidateMode
                                                    .onUserInteraction),

                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                          setState(() {
                                            _frmTelephone = value;
                                          });
                                        },

                                        keyboardType: TextInputType.number,

                                        //style: const TextStyle(fontSize: 12.5),
                                        style: const TextStyle(fontSize: 12.5),
                                        //maxLength: 9,
                                        scrollPadding: const EdgeInsets.all(0),

                                        //style: TextStyle( fontSize: 13 ),

                                        decoration: const InputDecoration(
                                          hintText: 'Ej: 096 875 326',
                                          border: InputBorder.none,
                                          helperStyle:
                                              TextStyle(fontSize: 10.0),
                                          labelText: 'Teléfono',
                                          //hintText: "Nota para el envío",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 8.0),
                                          errorStyle: TextStyle(fontSize: 10.0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                          //labelText: '¿Qué te pareció esta cerveza?',
                                          //helperText: 'Toda artesanál se hace con esfuerzo, intenta ser amable 😊',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: _horizontalPadding,
                                      right: _horizontalPadding,
                                      bottom: 0,
                                      top: 5.0),
                                  child: Row(
                                    children: const [
                                      Text("Ubicación",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                                const HopsAlert(
                                    iconSize: 18,
                                    internalPadding: EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: _horizontalPadding - 5),
                                    text:
                                        "En la próxima version ampliaremos a todo el país.",
                                    icon: Icons.info,
                                    color: Colors.blue),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 0),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0.0,
                                          top: 0,
                                          left: 10.0,
                                          right: 5.0),
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: _dropdownValue,
                                        hint: const Text(
                                            "Selecciona una ubicación",
                                            style: TextStyle(fontSize: 12.5)),
                                        // icon: const Icon(Icons.arrow_downward),
                                        iconSize: 25,
                                        elevation: 8,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 11),
                                        icon: const Icon(
                                          Icons.expand_more,
                                          size: 15,
                                        ),
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
                                        items: <String>['Montevideo', 'Rocha']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  fontSize: 12.5),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                if (1 == 2)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: _horizontalPadding,
                                        vertical: 8),
                                    child: TextFormField(
                                      initialValue: (snapshot.data != null
                                          ? snapshot.data.postCode
                                          : null),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          //return "Ingresa tu código postal.";
                                          return null;
                                        }
                                        if (!RegExp(r'.{4,}').hasMatch(value))
                                          return 'Sé un poco mas específico (al menos 5 letras o números).';
                                        if (value.length >= 700)
                                          return '¡Wow!, ¿podrías ser mas concret@?.';
                                        return null;
                                      },
                                      autovalidateMode:
                                          (this.formValidatedOnce == true
                                              ? AutovalidateMode.always
                                              : AutovalidateMode
                                                  .onUserInteraction),

                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                        setState(() {
                                          _frmCP = value;
                                        });
                                      },

                                      keyboardType: TextInputType.name,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: const TextStyle(fontSize: 12.5),

                                      //style: TextStyle( fontSize: 13 ),

                                      decoration: const InputDecoration(
                                        hintText: 'Código postal. Ej: 11200',
                                      ),
                                    ),
                                  ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 0),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                          top: 0,
                                          left: 5.0,
                                          right: 5.0),
                                      child: TextFormField(
                                        initialValue: (snapshot.data != null
                                            ? snapshot.data.city
                                            : null),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Ingresa tu localidad.";
                                          }
                                          if (!RegExp(r'.{5,}').hasMatch(value))
                                            return 'Sé un poco mas específico (al menos 5 letras o números).';
                                          if (value.length >= 700)
                                            return '¡Wow!, ¿podrías ser mas concret@?.';
                                          return null;
                                        },
                                        autovalidateMode:
                                            (this.formValidatedOnce == true
                                                ? AutovalidateMode.always
                                                : AutovalidateMode
                                                    .onUserInteraction),

                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                          setState(() {
                                            _frmLocation = value;
                                          });
                                        },

                                        keyboardType: TextInputType.name,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        style: const TextStyle(fontSize: 12.5),
                                        maxLength: 25,

                                        //style: TextStyle( fontSize: 13 ),

                                        decoration: const InputDecoration(
                                          hintText: 'Ej: Punta del Diablo',
                                          border: InputBorder.none,
                                          helperStyle:
                                              TextStyle(fontSize: 10.0),
                                          labelText: 'Localidad',
                                          //hintText: "Nota para el envío",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 8.0),
                                          errorStyle: TextStyle(fontSize: 10.0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 0),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                          top: 0,
                                          left: 5.0,
                                          right: 5.0),
                                      child: TextFormField(
                                        initialValue: (snapshot.data != null
                                            ? snapshot.data.address1
                                            : null),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Ingresa tu dirección.";
                                          }
                                          if (!RegExp(r'.{5,}').hasMatch(value))
                                            return 'Sé un poco mas específico (al menos 5 letras o números).';
                                          if (value.length >= 700)
                                            return '¡Wow!, ¿podrías ser mas concret@?.';
                                          return null;
                                        },
                                        autovalidateMode:
                                            (this.formValidatedOnce == true
                                                ? AutovalidateMode.always
                                                : AutovalidateMode
                                                    .onUserInteraction),

                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                          setState(() {
                                            _frmAddress1 = value;
                                          });
                                        },

                                        keyboardType: TextInputType.name,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        style: const TextStyle(fontSize: 12.5),
                                        maxLength: 50,

                                        //style: TextStyle( fontSize: 13 ),

                                        decoration: const InputDecoration(
                                          hintText: 'Ej: 18 de Julio 1451',
                                          border: InputBorder.none,
                                          helperStyle:
                                              TextStyle(fontSize: 10.0),
                                          labelText: 'Dirección',
                                          //hintText: "Nota para el envío",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 8.0),
                                          errorStyle: TextStyle(fontSize: 10.0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: _horizontalPadding - 5,
                                      vertical: 0),
                                  child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                          top: 0,
                                          left: 5.0,
                                          right: 5.0),
                                      child: TextFormField(
                                        initialValue: (snapshot.data != null
                                            ? snapshot.data.address2
                                            : null),
                                        validator: (value) {
                                          return null;
                                        },
                                        // autovalidateMode: (this.formValidatedOnce == true ? AutovalidateMode.always : AutovalidateMode.onUserInteraction ),

                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                          setState(() {
                                            _frmAddress2 = value;
                                          });
                                        },

                                        keyboardType: TextInputType.name,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        style: const TextStyle(fontSize: 12.5),

                                        //style: TextStyle( fontSize: 13 ),

                                        decoration: const InputDecoration(
                                          hintText: 'Ej: Apto 425',
                                          border: InputBorder.none,
                                          helperStyle:
                                              TextStyle(fontSize: 10.0),
                                          labelText: 'Piso/Apartamento',
                                          //hintText: "Nota para el envío",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 8.0),
                                          errorStyle: TextStyle(fontSize: 10.0),
                                          labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 150)
                              ],
                            ),
                          );
                        }
                    }
                  })),
        ),
      ),
    );
  }
}
