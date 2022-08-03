import 'package:Hops/components/help_action_button.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/models/login.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../components/error.dart';
import '../../components/hops_button.dart';
import '../../helpers.dart';
import '../../models/brewery.dart';

class OrdersView extends StatefulWidget {
  static const String routeName = "orders";
  const OrdersView({Key? key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  LoginResponse? _userData;
  late Future<List<dynamic>?> _customerOrders;

  @override
  void initState() {
    super.initState();
    _customerOrders = getOrders();
  }

  Future<List<dynamic>?> getOrders() async {
    _userData = await SharedServices.loginDetails();
    return await WordpressAPI.getOrders(_userData!.data!.id);
  }

  String _shortenPaymentMethodTitle(String title) {
    List<String> titles = title.split(" ");
    return titles[0];
  }

  String _buildItemsQuantity(List lineItems) {
    int quantity = 0;
    for (int i = 0; i < lineItems.length; i++) {
      quantity += int.parse(lineItems[i]["quantity"].toString());
      // order["line_items"].length.toString() +
      //                                 " " +
      //                                 "cerveza" +
      //                                 (order["line_items"].length > 1
      //                                     ? "s"
      //                                     : "")
    }
    return quantity.toString() + " " + "cerveza" + (quantity > 1 ? "s" : "");
  }

  Widget _buildSingleOrderBox(Map<String, dynamic> order) {
    String finalStatus = order["status"];
    Brewery brewery = Brewery.fromJson(order["brewery"]);
    IconData finalIcon = Icons.abc;
    Color finalColor = Colors.grey;

    String dateTimeAgo = order["date_created"];
    DateTime dateTImeAgoObject = DateTime.parse(dateTimeAgo);

    dateTimeAgo = timeago.format(dateTImeAgoObject, locale: 'es');

    // final fifteenAgo = DateTime.now().subtract(Duration(minutes: 15));

    // print(timeago.format(fifteenAgo)); // 15 minutes ago
    // print(timeago.format(fifteenAgo, locale: 'en_short')); // 15m
    // print(timeago.format(fifteenAgo, locale: 'es')); // hace 15 minut

    if (order["status"] == "pending") {
      finalStatus = "Pendiente de pago";
      finalIcon = Icons.hourglass_top;
      finalColor = Colors.redAccent.withOpacity(0.8);
    }
    if (order["status"] == "completed") {
      finalStatus = "Completado";
      finalIcon = Icons.check_circle;
      finalColor = Colors.green.withOpacity(0.8);
    }
    if (order["status"] == "processing") {
      finalStatus = "Preparando";
      finalIcon = Icons.delivery_dining;
      finalColor = Colors.blue.withOpacity(0.8);
    }
    if (order["status"] == "delivering") {
      finalStatus = "En camino";
      finalIcon = Icons.delivery_dining;
      finalColor = Colors.blue.withOpacity(0.8);
    }
    if (order["status"] == "cancelled") {
      finalStatus = "Cancelado";
      finalIcon = Icons.cancel;
      finalColor = Colors.black.withOpacity(0.8);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Image.network(
                                brewery.image,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(brewery.name,
                                      style: const TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    '${dateTimeAgo} - ' +
                                        _shortenPaymentMethodTitle(
                                            order["payment_method_title"]),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Text("Pedido #" + order["id"].toString(),
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 16.0),
                          //     textAlign: TextAlign.left),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.sports_bar,
                                size: 15,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(_buildItemsQuantity(order["line_items"]),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.paid,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text("\$" + order["total"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left),
                                ],
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(top: 12.0, bottom: 5.0),
                          //   child: Divider(
                          //     color: Colors.grey.withOpacity(.1),
                          //     thickness: 2.0,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HopsButton(
                                text: const Text(
                                  "Detalles",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                // padding: const EdgeInsets.all(0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5.0),
                                size: Size.zero,
                                icon: const Icon(
                                  Icons.info,
                                  size: 12.0,
                                ),
                                doOnPressed: () => Navigator.pushNamed(
                                    context, "/orderDetails", arguments: {
                                  'orderId': int.parse(order["id"].toString())
                                }),
                                bgColor: Colors.black87,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  finalStatus,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: finalColor),
                                ),
                              ),
                            ],
                          ),
                        ]),
                    // Positioned(
                    //     top: -5,
                    //     right: -25,
                    //     child: Transform(
                    //       transform: Matrix4.identity()..scale(.8),
                    //       child: Chip(
                    //         backgroundColor: finalColor,
                    //         avatar: CircleAvatar(
                    //             backgroundColor: Colors.white,
                    //             child: Icon(
                    //               finalIcon,
                    //               color: finalColor,
                    //               size: 11.0,
                    //             )),
                    //         label: Text(
                    //           finalStatus,
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 12,
                    //               color: Colors.white),
                    //         ),
                    //       ),
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderBoxes(List ordersList) {
    List<Widget> ordersFinalList = [];
    for (var i = 0; i < ordersList.length; i++) {
      ordersFinalList.add(_buildSingleOrderBox(ordersList[i]));
    }
    return Column(children: ordersFinalList);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _customerOrders = getOrders();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("Pedidos", style: TextStyle(color: Colors.black)),
          elevation: 0,
          actions: [
            const HelpActionButton(
              padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Carrito',
                  onPressed: () {
                    setState(() {
                      _customerOrders = getOrders();
                    });
                  },
                ),
              ),
            )
          ],
        ),
        // bottomNavigationBar: _buildFinishCheckoutButton(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                minWidth: double.infinity,
                maxHeight: double.infinity),
            child: FutureBuilder(
                future: _customerOrders,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              //child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,)
                              child: Image.asset(
                            "assets/images/loader-hops.gif",
                            width: 100,
                          )),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Cargando pedidos..."),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ));
                    default:
                      if (snapshot.hasError) {
                        return const ErrorMessage();
                      } else {
                        if (snapshot.data.length > 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: marginSide),
                            child: _buildOrderBoxes(snapshot.data),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Image.asset(
                                  "assets/images/loudly-crying-face_1f62d.png",
                                  height: 45,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      // TextSpan(text: "No hay ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                      TextSpan(
                                          text: "No hay pedidos.",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87))
                                    ]),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Incluye tus cervezas ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87)),
                                  ),
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "a través de la compra",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87)),
                                  ),
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "inmediata.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/'));
                                  },
                                  child: Wrap(spacing: 4.0, children: [
                                    Icon(Icons.sports_bar),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text("¡Descubrir cevezas ahora!"),
                                    )
                                  ]),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black.withOpacity(.6)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white.withOpacity(.8)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color:
                                                Colors.black.withOpacity(.2)),
                                      ))),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                  }
                }),
          ),
        )),
      ),
    );
  }
}
