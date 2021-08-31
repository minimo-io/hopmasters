import 'package:Hops/services/wordpress_api.dart';
import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/app_global_title.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/counter_selector.dart';
import 'package:Hops/utils/progress_hud.dart';

class CheckoutView extends StatefulWidget{

  static const String routeName = "/checkout";

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  double deliveryCost = 100.0;
  double bottomHeight = 70;
  bool isLoadingApiCall = false;

  @override
  void initState() {
    super.initState();

  }

  Widget _buildDeliveryMethodBox({String image = "", String name = "" , bool isSelected = false} ){
    return SizedBox(
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
        );
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
            child: Consumer<Cart>(
                builder: (context, cart, child){
                  return (cart.items.length > 0 ? ElevatedButton(

                    onPressed: (){
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
                      WordpressAPI.createOrder().then((value) {
                        print(value);
                        setState(() {
                          bottomHeight = 70;
                          isLoadingApiCall = false;
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
                  ) : Container() );
                }
            )
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
                          height: MediaQuery.of(context).size.height - 100,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                AppGlobalTitle(title: "Datos de envío", type: "title"),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 140,
                                    child: Card(
                                      elevation: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Stack(

                                          children: [
                                            Positioned(
                                                top: -19,
                                                right: -5,
                                                child: TextButton(
                                                    onPressed: () => print("pepe"),
                                                    child: Text("Cambiar", style: TextStyle(color: Colors.redAccent))
                                                )
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Nicolás Erramuspe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                                SizedBox(height: 10,),
                                                Text("Eduardo Acevedo 1376, apartamento 901"),
                                                Text("Montevideo, Uruguay"),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Icon(Icons.phone, size: 15,),
                                                    SizedBox(width: 3,),
                                                    Text("096.666.902"),
                                                  ],
                                                ),
                                              ],
                                            ),



                                          ],
                                        ),
                                      ),
                                    )
                                  ),
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
                                                      onPressed: () => print("pepe"),
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
                                    _buildDeliveryMethodBox(name: "Hops", image: "assets/images/hops-logo.png", isSelected: true),
                                    _buildDeliveryMethodBox(name: "BirraVa", image: "assets/images/birrava-logo.png"),
                                    _buildDeliveryMethodBox(name: "SabremosTomar", image: "assets/images/sabremostomar-logo.png"),

                                  ],
                                ),

                                SizedBox(height: 30,),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 17.0),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Orden",
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