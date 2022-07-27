import 'package:Hops/components/error.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/theme/style.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../helpers.dart';
import '../../models/login.dart';

// ignore: must_be_immutable
class OrderDetailsView extends StatefulWidget {
  static const String routeName = "/orderDetails";
  int orderId;
  OrderDetailsView({required this.orderId, Key? key}) : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  LoginResponse? _userData;
  late Future<dynamic?> _order;

  @override
  void initState() {
    super.initState();
    _order = getOrders(widget.orderId);
  }

  Future<List<dynamic>?> getOrders(int orderId) async {
    _userData = await SharedServices.loginDetails();
    return await WordpressAPI.getOrders(_userData!.data!.id, orderId: orderId);
  }

  Widget _buildFirstStepPending() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: true,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.white,
              //iconData: Icons.done,
              iconData: Icons.radio_button_unchecked,
              fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(87, 180, 74, 1)),
      beforeLineStyle: const LineStyle(color: Colors.grey),
      afterLineStyle: LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Esperando el pago ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(87, 180, 74, 1))),
            Text(
                "Deberás realizar la transferencia para que la cervecería procese el pedido",
                style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildFirstStepDone() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: true,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.white, iconData: Icons.done, fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(87, 180, 74, 1)),
      beforeLineStyle: const LineStyle(color: Colors.grey),
      afterLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pago recibido con éxito",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.grey)),
            // Text("Pago recibido correctamente.",
            //     style: TextStyle(fontSize: 11.0, color: Colors.grey))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildFirstStepCancelled() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: true,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.red,
              //iconData: Icons.done,
              iconData: Icons.cancel,
              fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: Colors.redAccent),
      beforeLineStyle: const LineStyle(color: Colors.grey),
      afterLineStyle: LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pedido cancelado",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.redAccent)),
            Text("Este pedido se ha cencelado y no se procesará",
                style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildSecondStepPending() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: IndicatorStyle(
        color: Colors.grey,
        width: 12,
        padding: const EdgeInsets.all(5),
      ),

      beforeLineStyle: LineStyle(color: Colors.grey),
      afterLineStyle: LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Preparando el pedido ", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildSecondStepProcessing() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: const IndicatorStyle(
        color: Color.fromRGBO(87, 180, 74, 1),
        width: 12,
        padding: EdgeInsets.all(5),
      ),

      beforeLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      afterLineStyle: const LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Preparando el pedido ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(87, 180, 74, 1))),
            Text(
                "La cervecería está preparando tu pedido y preparándose para enviarlo",
                style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildSecondStepDelivering() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.white, iconData: Icons.done, fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(87, 180, 74, 1)),

      beforeLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      afterLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("El pedido ya está pronto",
                style: TextStyle(color: Colors.grey)),
            // Text(
            //     "La cervecería está preparando tu pedido y preparándose para enviarlo",
            //     style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildThirdStepPending() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: IndicatorStyle(
          padding: const EdgeInsets.all(5), width: 12, color: Colors.grey),
      beforeLineStyle: LineStyle(color: Colors.grey),
      afterLineStyle: LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("En camino ", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildThirdStepDelivering() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: const IndicatorStyle(
          padding: EdgeInsets.all(5),
          width: 12,
          color: Color.fromRGBO(87, 180, 74, 1)),
      beforeLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      afterLineStyle: const LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("En camino",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(87, 180, 74, 1))),
            Text(
                "El pedido está saliendo para tu dirección de envío. Mantente atento.",
                style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildThirdStepDelivered() {
    return TimelineTile(
      // lineXY: 1,
      isFirst: false,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.white, iconData: Icons.done, fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(87, 180, 74, 1)),
      beforeLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      afterLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("En camino", style: TextStyle(color: Colors.grey)),
            // Text(
            //     "El pedido está saliendo para tu dirección de envío. Mantente atento.",
            //     style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildFourthStepNotCompleted() {
    return TimelineTile(
      // lineXY: 1,
      isLast: true,
      indicatorStyle: IndicatorStyle(
          padding: const EdgeInsets.all(5), width: 12, color: Colors.grey),
      beforeLineStyle: LineStyle(color: Colors.grey),
      afterLineStyle: LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Entregado", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildFourthStepCompleted() {
    return TimelineTile(
      // lineXY: 1,
      isLast: true,
      indicatorStyle: IndicatorStyle(
          iconStyle: IconStyle(
              color: Colors.white, iconData: Icons.done, fontSize: 10.0),
          width: 12,
          padding: const EdgeInsets.all(5),
          color: const Color.fromRGBO(87, 180, 74, 1)),
      beforeLineStyle: const LineStyle(color: Color.fromRGBO(87, 180, 74, 1)),
      afterLineStyle: const LineStyle(color: Colors.grey),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: const EdgeInsets.only(left: 30.0),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Entregado",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(87, 180, 74, 1))),
            Text("El pedido fue marcado como entregado por la cervecería.",
                style: TextStyle(fontSize: 11.0, color: Colors.black87))
          ],
        ),
      ),
      // startChild: Container(
      //   color: Colors.amberAccent,
      // ),
    );
  }

  Widget _buildTimeline(String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Row(
                children: [
                  Text("ENVÍO",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),

            // first step
            if (status == "pending") _buildFirstStepPending(),
            if (status == "cancelled") _buildFirstStepCancelled(),
            if (status != "pending" && status != "cancelled")
              _buildFirstStepDone(),

            // second step
            if (status == "pending" || status == "Xcancelled")
              _buildSecondStepPending(),
            if (status == "processing") _buildSecondStepProcessing(),
            if (status != "pending" &&
                status != "cancelled" &&
                status != "processing")
              _buildSecondStepDelivering(),

            // third step
            if (status == "pending" ||
                status == "Xcancelled" ||
                status == "processing")
              _buildThirdStepPending(),

            if (status == "delivering") _buildThirdStepDelivering(),
            if (status != "pending" &&
                status != "cancelled" &&
                status != "processing" &&
                status != "delivering")
              _buildThirdStepDelivered(),

            if (status != "completed" && status != "cancelled")
              _buildFourthStepNotCompleted(),
            if (status == "completed") _buildFourthStepCompleted(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(String paymentTitle, String orderTotal) {
    const double bankDetailsFontSize = 12.0;
    const TextStyle bankDetailsValues =
        TextStyle(fontSize: 13, color: Colors.black87);

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Text("PAGO: " + paymentTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Cuenta",
                        style: TextStyle(
                            fontSize: bankDetailsFontSize, color: Colors.grey)),
                    Text(
                      "001166629-00003",
                      style: bankDetailsValues,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Titular",
                        style: TextStyle(
                            fontSize: bankDetailsFontSize, color: Colors.grey)),
                    Text(
                      "Nicolas Erramuspe",
                      style: bankDetailsValues,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Banco",
                        style: TextStyle(
                            fontSize: bankDetailsFontSize, color: Colors.grey)),
                    Text(
                      "BROU",
                      style: bankDetailsValues,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total",
                        style: TextStyle(
                            fontSize: bankDetailsFontSize, color: Colors.grey)),
                    Text(
                      "\$" + orderTotal,
                      style: bankDetailsValues,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(List items) {
    List<Widget> listItems = [];
    TextStyle itemsStyle = TextStyle(fontSize: 13.0, color: Colors.grey);
    for (int i = 0; i < items.length; i++) {
      listItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "x" + items[i]["quantity"].toString() + " · " + items[i]["name"],
            style: itemsStyle,
          ),
          const SizedBox(
            width: 5.0,
          ),
        ],
      ));
    }
    return Column(
      children: listItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _order = getOrders(widget.orderId);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text("Pedido #" + widget.orderId.toString(),
              style: const TextStyle(color: Colors.black)),
          elevation: 0,
          automaticallyImplyLeading: true,
          actions: [
            FutureBuilder(
                future: _order,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 10.0),
                        child: InkWell(
                          onTap: () => Helpers.userAskedForHelp(),
                          child: Badge(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            toAnimate: false,
                            shape: BadgeShape.square,
                            borderRadius: BorderRadius.circular(20.0),
                            badgeColor: const Color.fromRGBO(77, 159, 0, .7),
                            badgeContent: Row(
                              children: [
                                Icon(
                                  Icons.help,
                                  size: 15.0,
                                  color: Colors.white.withOpacity(.8),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  'Ayuda',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.8),
                                      fontSize: 11.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      break;
                    default:
                      return Container();
                  }
                })
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: FutureBuilder(
                    future: _order,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight,
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
                                    child: Text("Cargando pedido  ..."),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ));
                        default:
                          if (snapshot.hasError) {
                            return const ErrorMessage();
                          } else {
                            Map<String, dynamic> order = snapshot.data[0];

                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: _buildTimeline(order["status"]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (order["payment_method"] == "bacs" &&
                                      order["status"] == "pending")
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: _buildPaymentInfo(
                                          order["payment_method_title"],
                                          order["total"]),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 20.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0,
                                                      vertical: 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.place,
                                                      size: 30,
                                                      color: Colors.grey),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Text(
                                              "Avenida Central S/N",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )),
                                            Center(
                                                child: Text(
                                              "Punta del Diablo, Rocha",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Text(
                                              "Recibe Nicolás Erramuspe . 096666902",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )),
                                            Center(
                                                child: Text(
                                              '"La casa blanca pasando el ómnibus, a media cuadra"',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 20.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0,
                                                      vertical: 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.shopping_cart,
                                                      size: 30,
                                                      color: Colors.grey),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Text(
                                              order["brewery"]["name"],
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            _buildOrderItems(
                                                order["line_items"])
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                                ],
                              ),
                            );
                          }
                      }
                    })),
          ),
        ),
      ),
    );
  }
}
