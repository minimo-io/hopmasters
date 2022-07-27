import 'package:Hops/components/order_details_box.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/models/brewery.dart';
import 'package:Hops/models/promo.dart';
import 'package:Hops/utils/notifications.dart';
import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/counter_selector.dart';

import 'package:badges/badges.dart';

import '../../models/order_data.dart';
import '../../services/shared_services.dart';

class CartView extends StatefulWidget {
  final String? name;
  final int? count;

  static const String routeName = "/cart";

  CartView({this.name, this.count});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late Future<OrderData?> _lastOrderData;

  @override
  void initState() {
    super.initState();
    _lastOrderData = SharedServices.lastShippingDetails();

    //SharedServices.removeLastShippingDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _lastOrderData.then((value){
      //   if (value != null){
      //     setState(() {
      //       bottomHeight = 70;
      //     });

      //   }else{
      //     setState(() {
      //       bottomHeight = 0;
      //     });

      //   }
      // });
    });
  }

  String _buildPriceText(CartItem cartItem) {
    int finalPrice = int.parse(cartItem.beer!.price!) * cartItem.itemCount;
    return "\$" + finalPrice.toString();
  }

  bool _isMinBuyOk(int breweryItemsCount, int promoMinBuy) {
    return (breweryItemsCount >= promoMinBuy ? true : false);
  }

  Widget _buildItemPrice(CartItem item, Cart cart) {
    int breweryItems = cart.countBreweryItems(int.parse(item.beer!.brewery.id));
    bool minBuyOk = false;
    if (item.beer!.brewery.promos != null &&
        item.beer!.brewery.promos!.isNotEmpty) {
      minBuyOk = _isMinBuyOk(
          breweryItems, item.beer!.brewery.promos!.first.minBuy ?? 0);
    }
    double itemPrice = item.itemPrice.roundToDouble();
    double discountedValue = 0.0;

    if (minBuyOk == true) {
      double discountValue = item.beer!.brewery.promos!.first.discountValue;
      discountedValue = cart.discountedItemPrice(itemPrice, discountValue);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        (discountedValue > 0.0
            ? Text("\$" + discountedValue.toString(),
                style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))
            : Container()),
        Text("\$" + item.itemPrice.round().toString(),
            style: TextStyle(
                fontSize: discountedValue > 0.0 ? 15.0 : 20.0,
                color: Colors.black,
                decoration: (discountedValue > 0.0
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildTopPromo(Brewery brewery, int breweryItemsCount) {
    if (brewery.promos != null && brewery.promos!.isNotEmpty) {
      String promoName = brewery.promos!.first.nameShort ?? "";
      int promoMinBuy = brewery.promos!.first.minBuy ?? 0;

      // evaluate if the amount is ok to apply
      bool minBuyOk = _isMinBuyOk(breweryItemsCount, promoMinBuy);

      return Badge(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        toAnimate: false,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(8),
        badgeColor: SECONDARY_BUTTON_COLOR.withOpacity(minBuyOk ? 1.0 : 0.4),
        badgeContent: Row(
          children: [
            minBuyOk
                ? const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.check_circle,
                      size: 15,
                      color: Colors.green,
                    ),
                  )
                : Container(),
            Text(
              promoName,
              style: const TextStyle(color: Colors.black54, fontSize: 11.0),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildBreweryItem(Brewery brewery, int breweryItemsCount) {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, bottom: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.network(
              //   brewery.image,
              //   width: 20,
              // ),
              // const SizedBox(
              //   width: 5.0,
              // ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  "/brewery",
                  arguments: {'breweryId': int.parse(brewery.id)},
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              brewery.name,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.chevron_right,
                                size: 15,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Badge(
                      elevation: 0,
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      animationDuration: const Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7.0, vertical: 5.0),
                      toAnimate: true,
                      shape: BadgeShape.circle,
                      borderRadius: BorderRadius.circular(8),
                      badgeColor: Colors.red.withOpacity(1),
                      badgeContent: Text(
                        breweryItemsCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              if (brewery.promos!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      "/brewery",
                      arguments: {'breweryId': int.parse(brewery.id)},
                    ),
                    child: Badge(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      toAnimate: false,
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(20.0),
                      badgeColor: Colors.black.withOpacity(.3),
                      badgeContent: Row(
                        children: [
                          Icon(
                            Icons.redeem,
                            size: 13.0,
                            color: Colors.white.withOpacity(.8),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'Ver promos',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 11.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // const SizedBox(
          //   height: 0.0,
          // ),
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.account_circle,
          //       size: 11.0,
          //       color: Colors.black54,
          //     ),
          //     const SizedBox(
          //       width: 3.0,
          //     ),
          //     Text("Ver cervecería",
          //         style: const TextStyle(
          //             color: Colors.black54, fontSize: 10.0, letterSpacing: .1))
          //     // Text(
          //     //     brewery.followers! +
          //     //         " seguidor" +
          //     //         (int.parse(brewery.followers!) > 1 ? "es" : ""),
          //     //     style: const TextStyle(
          //     //         color: Colors.black54, fontSize: 10.0, letterSpacing: .1))
          //   ],
          // ),
          const SizedBox(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: SECONDARY_BUTTON_COLOR,
                size: 18.0,
              ),
              const SizedBox(
                width: 3.0,
              ),
              Text(
                double.parse(brewery.scoreAvg.toString()).toString(),
                style: const TextStyle(
                    fontSize: 11.0, fontWeight: FontWeight.bold),
              ),
              Text(
                  " (" +
                      brewery.scoreCount.toString() +
                      " voto" +
                      (int.parse(brewery.scoreCount!) == 1 ? "" : "s") +
                      ")",
                  style: TextStyle(fontSize: 11.0)),
              const SizedBox(
                width: 5.0,
              ),
              _buildTopPromo(brewery, breweryItemsCount)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBeerBadgeData(Beer beer, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Badge(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        toAnimate: false,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(8),
        badgeColor: Colors.grey.withOpacity(.3),
        badgeContent: Text(
          text,
          style: TextStyle(color: Colors.black54, fontSize: 10.0),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, Cart cart,
      {bool showBreweryName = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/beer",
          arguments: {'beerId': int.parse(cartItem.beer!.beerId)},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: "beer-" + cartItem.beer!.beerId,
              child: Image.network(
                cartItem.beer!.image!,
                fit: BoxFit.cover, // this is the solution for border
                //width: 55.0,
                height: 70.0,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.beer!.name!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17.0),
                          textAlign: TextAlign.left),
                      if (showBreweryName)
                        Row(
                          children: <Widget>[
                            Image.network(
                              cartItem.beer!.breweryImage!,
                              height: 15,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                cartItem.beer!.breweryName!,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: SECONDARY_TEXT_DARK.withOpacity(1)),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Row(
                          children: [
                            _buildBeerBadgeData(cartItem.beer!,
                                cartItem.beer!.abv.toString() + " ABV"),
                            _buildBeerBadgeData(cartItem.beer!,
                                cartItem.beer!.ibu.toString() + " IBU"),
                          ],
                        ),
                      ),
                      CounterSelector(
                          counterInitCount: cartItem.itemCount,
                          counterPadding: const EdgeInsets.only(
                              left: 0, top: 12.0, right: 12.0, bottom: 12.0),
                          color: cartItem.beer!.rgbColor,
                          notifyParent: (int items) {
                            // setState( () => _itemsCount = items );
                            if (cartItem.itemCount < items) {
                              cart.modifyAmount(cartItem, "increase");
                            } else {
                              cart.modifyAmount(cartItem, "decrease");
                            }
                          }),
                    ]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildItemPrice(cartItem, cart),
                  const SizedBox(
                    height: 3,
                  ),
                  Consumer<Cart>(
                    builder: (context, cart, child) {
                      return InkWell(
                        onTap: () {
                          cart.remove(cartItem);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 10.0,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text("Remover",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 10.0)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Function()? _goToCheckout() {
    Navigator.pushNamed(
      context,
      "/checkout",
    );
  }

  Widget _buildCheckoutButton(OrderData? shippingDetails) {
    // MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    // MaterialStateProperty<Color?>? backgroundColor =
    //     MaterialStateProperty.all<Color>(
    //         SECONDARY_BUTTON_COLOR.withOpacity(.65));

    MaterialStateProperty<Color?>? backgroundColor =
        MaterialStateProperty.all<Color>(const Color.fromRGBO(77, 159, 0, 1));

    MaterialStateProperty<Color?>? backgroundColorGrey =
        MaterialStateProperty.all<Color>(Colors.grey);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 70,
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        gradient: PRIMARY_GRADIENT_COLOR,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
        child: SizedBox(
            width: double.infinity,
            child: Consumer<Cart>(builder: (context, cart, child) {
              String checkoutButtonText = "IR AL PAGO";
              if (!cart.validateSell) {
                if (cart.getBreweriesFromCart().length > 1) {
                  checkoutButtonText = "COMPLETAR PEDIDOS MÍNIMOS";
                } else {
                  checkoutButtonText = "COMPLETAR PEDIDO MÍNIMO";
                }
              }

              if (!cart.isShippingDataOk(shippingDetails)) {
                checkoutButtonText = "COMPLETAR DATOS DE ENVÍO";
              }

              return (cart.items.isNotEmpty
                  ? ElevatedButton(
                      onPressed: cart.validateSell &&
                              cart.isShippingDataOk(shippingDetails)
                          ? _goToCheckout
                          : null,
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 25.0)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black.withOpacity(1)),
                          backgroundColor: cart.validateSell && cart.isShippingDataOk(shippingDetails)
                              ? backgroundColor
                              : backgroundColorGrey,
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: cart.validateSell && cart.isShippingDataOk(shippingDetails)
                                      ? const Color.fromRGBO(77, 159, 0, 1)
                                      : Colors.grey)))),
                      child: Row(
                        mainAxisAlignment: (cart.validateSell &&
                                cart.isShippingDataOk(shippingDetails)
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center),
                        children: [
                          Row(
                            children: [
                              if (cart.validateSell &&
                                  cart.isShippingDataOk(shippingDetails))
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(checkoutButtonText,
                                  //"Finalizar compra",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ],
                          ),
                          if (cart.validateSell &&
                              cart.isShippingDataOk(shippingDetails))
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sports_bar,
                                      size: 18.0,
                                      color: Colors.white.withOpacity(.5),
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(cart.itemsCount.toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Colors.white.withOpacity(.5))),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.paid,
                                      size: 18.0,
                                      color: Colors.white.withOpacity(.5),
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      cart.finalPrice().toString(),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white.withOpacity(.5)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping,
                                      size: 18.0,
                                      color: Colors.white.withOpacity(.5),
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      "\$" +
                                          cart.totalDeliveryCost
                                              .round()
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white.withOpacity(.5)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ],
                      ),
                    )
                  : Container());
            })),
      ),
    );
  }

  Widget _buildCartSummaryBox(Brewery brewery) {
    double valuesSizes = 11.0;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Card(
            color: Colors.grey.withOpacity(.25),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Llega en",
                            style: TextStyle(fontSize: valuesSizes),
                          ),
                          Text(
                            brewery.deliveryTime.toString(),
                            style: TextStyle(
                                fontSize: valuesSizes,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Costo envío",
                            style: TextStyle(fontSize: valuesSizes),
                          ),
                          Text(
                            "\$" + brewery.deliveryCost.toString(),
                            style: TextStyle(
                                fontSize: valuesSizes,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Pedido mínimo",
                            style: TextStyle(fontSize: valuesSizes),
                          ),
                          Text(
                            brewery.deliveryMin.toString() + " cervezas",
                            style: TextStyle(
                                fontSize: valuesSizes,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget _buildOrdersAlertBox(Cart cart) {
    int breweriesCount = cart.getBreweriesFromCart().length;

    if (breweriesCount > 1) {
      return Card(
        elevation: cardsElevations,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.redAccent,
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                  child: Text(
                      "Recuerda que estas comprando directamente a las cervecerías. Por lo tanto cada pedido se procesará por separado.",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.normal)))
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FutureBuilder(
          future: _lastOrderData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _buildCheckoutButton(snapshot.data);
                }
            }
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              decoration: const BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child: Consumer<Cart>(builder: (context, cart, child) {
                //print("Cart items: " + cart.items.length.toString()); products go inside this
                List<Widget> cartItemsList = [];
                List<Brewery> breweries = cart.breweries;

                for (var b = 0; b < breweries.length; b++) {
                  // build brewery tag
                  cartItemsList.add(Column(
                    children: [
                      SizedBox(
                        height: (b == 0 ? 10 : 40),
                      ),
                      _buildBreweryItem(breweries[b],
                          cart.countBreweryItems(int.parse(breweries[b].id))),
                      _buildCartSummaryBox(breweries[b]),
                    ],
                  ));

                  // load beers for breweries
                  List<Widget> groupedBeers = [];
                  for (var i = 0; i < cart.items.length; i++) {
                    if (breweries[b].id == cart.items[i].beer!.brewery.id) {
                      // cartItemsList.add(_buildCartItem(cart.items[i], cart, showBreweryName: false));
                      groupedBeers.add(_buildCartItem(cart.items[i], cart,
                          showBreweryName: false));
                    }
                  }

                  // add beer group item box
                  cartItemsList.add(Card(
                    elevation: 1,
                    child: Column(
                      children: groupedBeers,
                    ),
                  ));
                }

                //cartItemsList.add(SizedBox(height: 90,));
                // print(cartItemsList.length.toString());

                return Container(
                    padding: const EdgeInsets.only(
                        top: 0, left: 15.0, right: 15, bottom: 15),
                    // padding: EdgeInsets.only(top: 50),
                    height: MediaQuery.of(context).size.height - 100,
                    child: SingleChildScrollView(
                      child: (cartItemsList.isNotEmpty
                          ? Column(
                              children: [
                                FutureBuilder(
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
                                          }
                                      }
                                    }),
                                // build alert box for order(s), if needed
                                _buildOrdersAlertBox(cart),
                                // add actual breweries and beers
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 90.0, top: 10.0),
                                  child: Column(
                                    children: cartItemsList,
                                  ),
                                ),
                              ],
                            )
                          : Padding(
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
                                      text: const TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: "Tu carrito ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black87)),
                                        TextSpan(
                                            text: "está vacío.",
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
                                        child:
                                            Text("¡Descubrir cevezas ahora!"),
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
                            )),
                    ));
              })),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),
        title: const Text("Carrito",
            style: TextStyle(
              color: Colors.black,
            )),
        elevation: 0,
        actions: [
          Consumer<Cart>(builder: (context, cart, child) {
            return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: (cart.items.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton.icon(
                          onPressed: () {
                            cart.removeAll();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 10.0,
                          ),
                          label: const Text("Remover todo",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 10.0)),
                        ),
                      )
                    : Container()));
          })
        ],
      ),
    );
  }
}
