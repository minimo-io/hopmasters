import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/app_global_title.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/counter_selector.dart';

class CheckoutView extends StatefulWidget{

  static const String routeName = "/checkout";

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {


  @override
  Widget build(BuildContext context){

    return Scaffold(
      // bottomNavigationBar: _buildCheckoutButton(),
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
                              AppGlobalTitle(title: "Dirección de envío", type: "title"),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 120,
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
                                              Text("Montevideo, Uruguay")
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
        /*
        actions: [
          Consumer<Cart>(
              builder: (context, cart, child){
                return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: (
                        cart.items.length > 0
                            ? TextButton.icon(
                          onPressed: (){
                            cart.removeAll();
                          },
                          icon: Icon(Icons.close, color: Colors.red,),
                          label: Text("Remover todo", style: TextStyle(color: Colors.red)),
                        ) : Container())
                );
              }
          )

        ],
        */
      ),
    );
  }
}