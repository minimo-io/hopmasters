
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

class CheckoutView extends StatefulWidget{

  static const String routeName = "/checkout";

  CheckoutView();

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  double deliveryCost = 100.0;
  double bottomHeight = 0;
  bool isLoadingApiCall = false;
  late Future<OrderData?> _lastOrderData;

  @override
  void initState() {

    super.initState();
    _lastOrderData = SharedServices.lastShippingDetails();

    WidgetsBinding.instance?.addPostFrameCallback((_){

      _lastOrderData.then((value){
        if (value != null){
          setState(() {
            bottomHeight = 70;
          });

        }else{
          setState(() {
            bottomHeight = 0;
          });

        }
      });

    });

  }

  Widget _buildDeliveryMethodBox({String image = "", String name = "" , bool isSelected = false, Function()? tapAction} ){
    return InkWell(
      onTap: (tapAction != null ? tapAction : null),
      child: SizedBox(
          width: (MediaQuery.of(context).size.width / 3 ) - 10,
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
                      Image.asset(image, height: 50, width: 50,),
                      SizedBox(height: 3,),
                      Text(name, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
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

  Widget _buildFinishCheckoutButton(){
    // MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));
    return AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      height: bottomHeight,
      padding: EdgeInsets.only( bottom: 5 ),
      decoration: BoxDecoration(
        gradient: PRIMARY_GRADIENT_COLOR,
      ),
      child: Consumer<Cart>(
          builder: (context, cart, child){
            return (cart.items.length > 0 ? Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  onPressed: ()async{
                    /*
                    Navigator.pushNamed(
                      context,
                      "/checkout",
                      // arguments: { 'breweryId': int.parse(breweries[i].id) },

                    );

                     */
                    setState(() {
                      bottomHeight = 0;
                      isLoadingApiCall = true;
                    });

                    LoginResponse? loginData = await SharedServices.loginDetails();
                    OrderData? orderData = await SharedServices.lastShippingDetails();




                    // get last shipping details from stored shared services
                    OrderData newOrder = new OrderData(
                      customerId: loginData!.data!.id.toString(), // we use the login data
                      firstName: orderData!.firstName,
                      lastName: orderData.lastName,
                      telephone: orderData.telephone,
                      email: loginData.data!.email, // we use the login data
                      paymentType: "cod", // cash on delivery
                      status: "processing",
                      address1: orderData.address1,
                      address2: orderData.address2,
                      city: orderData.city,
                      state: orderData.state,
                      country: orderData.country,
                      postCode: orderData.postCode,
                      beersList: cart.getShippingList(),
                      shippingMethodId: "flat_rate",
                      shippingRate: deliveryCost.toString()

                    );


                    BuildContext oldContext = context;

                    SharedServices.lastShippingDetails().then((lastOrderData){
                      SharedServices.setLastShippingDetails(newOrder).then((value){

                         WordpressAPI.createOrder(newOrder).then((result) {
                           var notificationClient = new HopsNotifications();
                           setState(() {
                             bottomHeight = 70;
                             isLoadingApiCall = false;
                           });
                          if (true == result){
                            // redirect to the order list view
                            cart.removeAll();
                            notificationClient.message(context, WordpressAPI.MESSAGE_OK_CREATEORDER, action: "", callback: (){
                              /*
                              Navigator.pushNamed(
                                  context,
                                  "orders"
                              );

                               */
                            });
                            notificationClient.message(context, "Por cierto, ¡ganate puntos HOPS!", action: "");
                            notificationClient.message(context, "Miralo en tu de perfil de usuario.", action: "");

                            Navigator.of(context).popUntil(ModalRoute.withName('/'));


                          }else{

                            notificationClient.message(context, WordpressAPI.MESSAGE_ERROR_CREATEORDER);
                          }

                        });

                      });

                    });



                  },
                  child: Text(
                      "Realizar pedido " + "(\$" + (cart.finalPrice() + deliveryCost).round().toString() + ")",
                      //"Finalizar compra",
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
                ),
              ),
            ) : Container() );
          }
      ),
    );
  }
  Widget _buildOrderDetailsBox(OrderData lastOrder){

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

                        _lastOrderData = SharedServices.lastShippingDetails();
                        bottomHeight = 70;

                      }));
                    },
                    child: Text("Cambiar", style: TextStyle(color: Colors.redAccent))
                )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lastOrder.firstName! + " " + lastOrder.lastName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                SizedBox(height: 10,),
                Text( (lastOrder.address1 != null ? lastOrder.address1 : "")! + ", " + (lastOrder.address2 != null ? lastOrder.address2 : "")!),
                Text(lastOrder.city!  + ", " + lastOrder.country! + ". CP: " + lastOrder.postCode!),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.phone, size: 15,),
                    SizedBox(width: 3,),
                    Text(lastOrder.telephone!),
                  ],
                ),
              ],
            )
          ],
        )
        )
      ),
    );


  }

  Widget _buildAddOrderDetailsButton(){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: ElevatedButton(
          onPressed: (){
            Navigator.pushNamed(
              context,
              "shippingDetails",
              // arguments: { 'beerId': int.parse(beer.beerId) },

            ).then((_) => setState(() {

              _lastOrderData = SharedServices.lastShippingDetails();
              bottomHeight = 70;

            }));
          },
          child: Text("Agregar datos de envío", style: TextStyle( fontSize: 17 ),),

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
      ),
    );
  }


  @override
  Widget build(BuildContext context){

    return ProgressHUD(
      inAsyncCall: isLoadingApiCall,
      opacity: 0.5,
      child: Scaffold(
        // bottomNavigationBar: _buildCheckoutButton(),
        bottomNavigationBar: _buildFinishCheckoutButton(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: Consumer<Cart>(
                    builder: (context, cart, child){

                      return Container(

                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width,
                          // padding: EdgeInsets.only(top: 50),
                          //height: MediaQuery.of(context).size.height - 100,
                          //height: MediaQuery.of(context).size.height,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                AppGlobalTitle(title: "Datos de envío", type: "title"),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: FutureBuilder(
                                            future: _lastOrderData,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              switch (snapshot.connectionState) {
                                                case ConnectionState
                                                    .waiting:
                                                  return SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(
                                                        color: PROGRESS_INDICATOR_COLOR,
                                                        strokeWidth: 1,));
                                                default:
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot
                                                            .error}');
                                                  } else {
                                                    return  snapshot.data != null
                                                          ? _buildOrderDetailsBox(snapshot.data)
                                                          : _buildAddOrderDetailsButton();




                                                  }
                                              }
                                            }
                                        )

                                ),
                                SizedBox(height: 20,),

                                /*
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppGlobalTitle(title: "Pago", type: "title"),
                                    TextButton(
                                        onPressed: () => print("pepe"),
                                        child: Text("Cambiar", style: TextStyle(color: Colors.redAccent))
                                    )
                                  ],
                                )

                                 */

                                AppGlobalTitle(title: "Pago", type: "title"),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 70,
                                      child: Card(
                                        elevation: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Stack(

                                            children: [
                                              Positioned(
                                                  top: -13,
                                                  right: -5,
                                                  child: TextButton(
                                                      onPressed: (){

                                                      },
                                                      child: Text("Cambiar", style: TextStyle(color: Colors.black38))
                                                  )
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Contra-reembolso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                                ],
                                              ),



                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20,),
                                AppGlobalTitle(title: "Envío", type: "title"),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildDeliveryMethodBox(name: "Hops", image: "assets/images/hops-logo-delivery.png", isSelected: true),
                                    _buildDeliveryMethodBox(name: "Uber", image: "assets/images/uber-logo.png", tapAction: (){
                                      var notificationClient = new HopsNotifications();
                                      notificationClient.message(context, "¡En próximas versiones!");
                                    }),
                                    _buildDeliveryMethodBox(name: "DAC", image: "assets/images/dac-logo.png", tapAction: (){
                                      var notificationClient = new HopsNotifications();
                                      notificationClient.message(context, "¡En próximas versiones!");
                                    }),
                                    /*
                                    _buildDeliveryMethodBox(name: "BirraVa", image: "assets/images/birrava-logo.png"),
                                    _buildDeliveryMethodBox(name: "SabremosTomar", image: "assets/images/sabremostomar-logo.png"),
                                    */
                                  ],
                                ),

                                SizedBox(height: 30,),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Pedido",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF444444))),
                                      Text("\$" + cart.finalPrice().round() .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF212121))),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Envío",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF444444))),
                                      Text("\$" + deliveryCost.round().toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF212121))),
                                    ],
                                  ),
                                ),
                                /*
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Divider(color: Colors.black.withOpacity(.6), thickness: 1.0,),
                                ),
                                */
                                SizedBox(height: 5,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("TOTAL",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF444444))),
                                      Text("\$" + (cart.finalPrice() + deliveryCost).round().toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF212121))),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 300,),


                              ],
                            ),
                          )
                      );
                    }
                )

            ),
          ),
        ),

        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR
            ),
          ),
          title: Text("Finalizar la compra"),
          elevation: 0,
        ),
      ),
    );
  }
}