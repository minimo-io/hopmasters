import 'package:Hops/components/card_horizontal.dart';
import 'package:Hops/components/hops_alert.dart';
import 'package:Hops/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/beer.dart';
import 'package:Hops/models/order_data.dart';
import 'package:Hops/models/login.dart';

import 'package:Hops/components/app_global_title.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/counter_selector.dart';
import 'package:Hops/utils/progress_hud.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/services/shared_services.dart';

import '../../components/order_details_box.dart';
import 'dart:ui';

import '../../helpers.dart';
import '../../models/brewery.dart';
import '../../models/payment.dart';

class CheckoutView extends StatefulWidget {
  static const String routeName = "/checkout";

  CheckoutView();

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  double bottomHeight = 0;
  bool isLoadingApiCall = false;
  late Future<OrderData?> _lastOrderData;
  late var _paymentSelected;

  final _orderNotesController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _orderNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _lastOrderData = SharedServices.lastShippingDetails();
    _paymentSelected = Payment(
        id: "bacs",
        icon: Icons.account_balance,
        title: "Transferencia bancaria",
        description:
            "Deposita en la cuenta que te mostraremos y comenzaremos a procesar tu pedido.",
        enabled: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lastOrderData.then((value) {
        if (value != null) {
          setState(() {
            bottomHeight = 70;
          });
        } else {
          setState(() {
            bottomHeight = 0;
          });
        }
      });
    });
  }

  Widget _buildDeliveryMethodBox(
      {String image = "",
      String name = "",
      bool isSelected = false,
      Function()? tapAction}) {
    return InkWell(
      onTap: (tapAction != null ? tapAction : null),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width / 3) - 10,
        height: 120,
        child: Card(
          color: (isSelected ? Colors.black.withOpacity(.2) : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.black.withOpacity(.6),
              width: (isSelected ? 0.0 : 0.0),
            ),
          ),
          elevation: 100,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 50,
                  width: 50,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15)),
                //SizedBox(height: 10,),
                //Text("Eduardo Acevedo 1376, apartamento 901"),
                //Text("Montevideo, Uruguay")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishCheckoutButton() {
    MaterialStateProperty<Color?>? backgroundColor =
        MaterialStateProperty.all<Color>(const Color.fromRGBO(77, 159, 0, 1));

    MaterialStateProperty<Color?>? backgroundColorGrey =
        MaterialStateProperty.all<Color>(Colors.grey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: bottomHeight,
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        gradient: PRIMARY_GRADIENT_COLOR,
      ),
      child: Consumer<Cart>(builder: (context, cart, child) {
        return (cart.items.isNotEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        bottomHeight = 0;
                        isLoadingApiCall = true;
                      });

                      LoginResponse? loginData =
                          await SharedServices.loginDetails();
                      OrderData? orderData =
                          await SharedServices.lastShippingDetails();

                      // define order status by payment method
                      String paymentStatus = "processing";
                      switch (_paymentSelected.id) {
                        case "bacs":
                          paymentStatus = "pending";
                          break;
                      }

                      // create one order per brewery, then capture this to send an email and create safe logs
                      List<Brewery> breweries = cart.getBreweriesFromCart();
                      List<bool> ordersResults = [];

                      await Future.forEach(breweries, (Brewery brewery) async {
                        OrderData newOrder = OrderData(
                            customerId: loginData!.data!.id
                                .toString(), // we use the login data
                            customerNote: _orderNotesController.text,
                            firstName: orderData!.firstName,
                            lastName: orderData.lastName,
                            telephone: orderData.telephone,
                            email:
                                loginData.data!.email, // we use the login data
                            paymentType: _paymentSelected.id,
                            paymentTypeTitle: _paymentSelected.title,
                            status: paymentStatus,
                            address1: orderData.address1,
                            address2: orderData.address2,
                            city: orderData.city,
                            state: orderData.state,
                            country: orderData.country,
                            postCode: orderData.postCode,
                            beersList: cart.getShippingList(brewery: brewery),
                            shippingMethodId: "flat_rate",
                            shippingRate: brewery.deliveryCost.toString());

                        // OrderData? lastOrderData = await SharedServices.lastShippingDetails();
                        await SharedServices.setLastShippingDetails(newOrder);
                        bool result = await WordpressAPI.createOrder(newOrder);
                        if (true == result) {
                          ordersResults.add(true);
                        } else {
                          ordersResults.add(false);
                        }
                      });

                      //await Future.delayed(const Duration(milliseconds: 3000));
                      // orders created now remove cart and redirect with params
                      double savedTotalAmount = double.parse(
                          (cart.finalPrice() + cart.totalDeliveryCost)
                              .round()
                              .toString());

                      cart.removeAll();

                      setState(() {
                        bottomHeight = 70;
                        isLoadingApiCall = false;
                      });

                      //Navigator.of(context).popUntil(ModalRoute.withName('/'));ç

                      Navigator.pushNamed(context, "/orderResults", arguments: {
                        'results': ordersResults.toString(),
                        'payment': _paymentSelected.id,
                        'amount': savedTotalAmount
                      });
                    },
                    child: Text("Realizar pedido ",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 25.0)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black.withOpacity(1)),
                        backgroundColor:
                            1 == 1 ? backgroundColor : backgroundColorGrey,
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(
                                        color: 1 == 1
                                            ? Color.fromRGBO(77, 159, 0, 1)
                                            : Colors.grey)))),
                  ),
                ),
              )
            : Container());
      }),
    );
  }

  Widget _buildOrderDetailsBox(OrderData lastOrder) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Card(
          elevation: 100,
          //color: Colors.transparent,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Positioned(
                      top: -19,
                      right: -5,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "shippingDetails",
                              // arguments: { 'beerId': int.parse(beer.beerId) },
                            ).then((_) => setState(() {
                                  _lastOrderData =
                                      SharedServices.lastShippingDetails();
                                  bottomHeight = 70;
                                }));
                          },
                          child: const Text("Cambiar",
                              style: TextStyle(color: Colors.redAccent)))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lastOrder.firstName! + " " + lastOrder.lastName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      SizedBox(
                        height: 10,
                      ),
                      Text((lastOrder.address1 != null
                              ? lastOrder.address1
                              : "")! +
                          ", " +
                          (lastOrder.address2 != null
                              ? lastOrder.address2
                              : "")!),
                      Text(lastOrder.city! +
                          ", " +
                          lastOrder.country! +
                          ". CP: " +
                          lastOrder.postCode!),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(lastOrder.telephone!),
                        ],
                      ),
                    ],
                  )
                ],
              ))),
    );
  }

  Widget _buildAddOrderDetailsButton() {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              "shippingDetails",
              // arguments: { 'beerId': int.parse(beer.beerId) },
            ).then((_) => setState(() {
                  _lastOrderData = SharedServices.lastShippingDetails();
                  bottomHeight = 70;
                }));
          },
          child: Text(
            "Agregar datos de envío",
            style: TextStyle(fontSize: 17),
          ),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.black.withOpacity(.6)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.white.withOpacity(.8)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black.withOpacity(.2)),
              ))),
        ),
      ),
    );
  }

  Widget _buildTotalPrice(Cart cart) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pago total",
          style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.withOpacity(.6),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black.withOpacity(.65),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              (cart.finalPrice() + cart.totalDeliveryCost).round().toString(),
              style: TextStyle(
                fontSize: 55.0,
                color: Colors.black.withOpacity(.65),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          width: 100,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Badge(
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
              toAnimate: false,
              shape: BadgeShape.square,
              borderRadius: BorderRadius.circular(20.0),
              badgeColor: Colors.black.withOpacity(.1),
              badgeContent: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_bar,
                    size: 13.0,
                    color: Colors.black.withOpacity(.8),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    cart.itemsCount.toString() + ' cervezas',
                    style: TextStyle(
                        color: Colors.black.withOpacity(.8), fontSize: 11.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderBreweriesSummary(Cart cart) {
    List<Brewery> breweries = cart.getBreweriesFromCart();
    List<Widget> listBreweriesDetails = [];
    TextStyle textStyle = const TextStyle(fontSize: 12);
    for (int i = 0; i < breweries.length; i++) {
      String breweryItems =
          cart.countBreweryItems(int.parse(breweries[i].id)).toString();

      listBreweriesDetails.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("... " + breweries[i].name + " (x" + breweryItems + ")",
                style: textStyle),
            Text(
                "\$" +
                    cart
                        .finalPrice(breweryId: int.parse(breweries[i].id))
                        .toString(),
                style: textStyle)
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: listBreweriesDetails,
      ),
    );
  }

  Widget _buildOrderDeliverySummary(Cart cart) {
    List<Brewery> breweries = cart.getBreweriesFromCart();
    List<Widget> listBreweriesDetails = [];
    TextStyle textStyle = const TextStyle(fontSize: 12);
    for (int i = 0; i < breweries.length; i++) {
      String breweryItems =
          cart.countBreweryItems(int.parse(breweries[i].id)).toString();

      listBreweriesDetails.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("... " + breweries[i].name, style: textStyle),
            Text("\$" + breweries[i].deliveryCost!.round().toString(),
                style: textStyle)
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: listBreweriesDetails,
      ),
    );
  }

  Widget _buildOrderCommentBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.only(
              bottom: 10.0, top: 0, left: 5.0, right: 5.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 70.0,
            ),
            child: TextFormField(
              // onSaved: (String? value) {
              //   setState(() {});
              // },
              controller: _orderNotesController,
              maxLength: 100,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 11.0),
              maxLines: null,

              expands: false,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.all(0),
              decoration: const InputDecoration(
                border: InputBorder.none,
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: 'Nota para el envío',
                //hintText: "Nota para el envío",
                contentPadding: EdgeInsets.all(5.0),
                labelStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
              //          controller: _text,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.9,
      text: "Enviando pedido(s)...",
      child: Scaffold(
        // bottomNavigationBar: _buildCheckoutButton(),
        bottomNavigationBar: _buildFinishCheckoutButton(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: Consumer<Cart>(builder: (context, cart, child) {
                  return Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.only(top: 50),
                      //height: MediaQuery.of(context).size.height - 100,
                      //height: MediaQuery.of(context).size.height,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            _buildTotalPrice(cart),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 5.0),
                              child: Row(
                                children: const [
                                  Text("Opciones del pedido ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 1.0),
                                child: FutureBuilder(
                                    future: _lastOrderData,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
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
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return OrderDetailsBox(
                                              onChangeShippingDetails: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  "shippingDetails",
                                                  // arguments: { 'beerId': int.parse(beer.beerId) },
                                                ).then((_) => setState(() {
                                                      _lastOrderData =
                                                          SharedServices
                                                              .lastShippingDetails();
                                                      //bottomHeight = 70;
                                                    }));
                                              },
                                              lastOrder: snapshot.data,
                                            );
                                            ;
                                          }
                                      }
                                    })),

                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CardHorizontal(
                                  icon: Icon(
                                    _paymentSelected.icon,
                                    size: 20,
                                  ),
                                  text: _paymentSelected.title,
                                  padding: 15.0,
                                  onTap: () async {
                                    final payment = await Navigator.pushNamed(
                                        context, "/payments");

                                    if (payment != null)
                                      setState(() {
                                        _paymentSelected = payment;
                                      });
                                  },
                                )),

                            if (cart.getBreweriesFromCart().length > 1)
                              const HopsAlert(
                                text: moreThanOneBreweryInOrder,
                                icon: Icons.warning,
                                color: Colors.redAccent,
                                cardElevation: 1,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 3.0),
                              ),
                            const SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 0.0),
                              child: Row(
                                children: const [
                                  Text("¿Alguna aclaración?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            _buildOrderCommentBox(),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 5.0),
                              child: Row(
                                children: const [
                                  Text("Resumen",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     _buildDeliveryMethodBox(
                            //         name: "Hops",
                            //         image:
                            //             "assets/images/hops-logo-delivery.png",
                            //         isSelected: true),
                            //     _buildDeliveryMethodBox(
                            //         name: "Uber",
                            //         image: "assets/images/uber-logo.png",
                            //         tapAction: () {
                            //           var notificationClient =
                            //               new HopsNotifications();
                            //           notificationClient.message(
                            //               context, "¡En próximas versiones!");
                            //         }),
                            //     _buildDeliveryMethodBox(
                            //         name: "DAC",
                            //         image: "assets/images/dac-logo.png",
                            //         tapAction: () {
                            //           var notificationClient =
                            //               new HopsNotifications();
                            //           notificationClient.message(
                            //               context, "¡En próximas versiones!");
                            //         }),
                            //     /*
                            //         _buildDeliveryMethodBox(name: "BirraVa", image: "assets/images/birrava-logo.png"),
                            //         _buildDeliveryMethodBox(name: "SabremosTomar", image: "assets/images/sabremostomar-logo.png"),
                            //         */
                            //   ],
                            // ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17.0),
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "Pedido" +
                                          (cart.getBreweriesFromCart().length >
                                                  1
                                              ? "s"
                                              : ""),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF444444))),
                                  Text(
                                      "\$" +
                                          cart.finalPrice().round().toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF212121))),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17.0),
                              child: _buildOrderBreweriesSummary(cart),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "Envío" +
                                          (cart.getBreweriesFromCart().length >
                                                  1
                                              ? "s"
                                              : ""),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF444444))),
                                  Text(
                                      "\$" +
                                          cart.totalDeliveryCost
                                              .round()
                                              .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF212121))),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17.0, vertical: 0.0),
                              child: _buildOrderDeliverySummary(cart),
                            ),
                            /*
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Divider(color: Colors.black.withOpacity(.6), thickness: 1.0,),
                                ),
                                */
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: marginSide),
                              child: SizedBox(
                                height: 1.0,
                                child: Divider(
                                  color: Colors.black.withOpacity(.5),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17.0),
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text("TOTAL",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF444444))),
                                  Text(
                                      "\$" +
                                          (cart.finalPrice() +
                                                  cart.totalDeliveryCost)
                                              .round()
                                              .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF212121))),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 300,
                            ),
                          ],
                        ),
                      ));
                })),
          ),
        ),

        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("", style: TextStyle(color: Colors.black)),
          elevation: 0,
          actions: [
            Consumer<Cart>(builder: (context, cart, child) {
              return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: (cart.items.isNotEmpty
                      ? Padding(
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
                        )
                      : Container()));
            })
          ],
        ),
      ),
    );
  }
}
