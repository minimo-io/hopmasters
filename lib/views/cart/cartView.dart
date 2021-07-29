import 'package:flutter/material.dart';

import 'package:Hops/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:Hops/models/cart.dart';
import 'package:Hops/models/beer.dart';

import 'package:Hops/components/stars_score.dart';
import 'package:Hops/components/counter_selector.dart';

class CartView extends StatefulWidget{
  final String? name;
  final int? count;

  static const String routeName = "/cart";

  CartView({ this.name, this.count });

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {

  String _buildPriceText(CartItem cartItem){
    int finalPrice = int.parse(cartItem.beer!.price!) * cartItem.itemCount;
    return "\$" + finalPrice.toString();
  }
  Widget _buildCartItem(CartItem cartItem, Cart cart){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          context,
          "/beer",
          arguments: { 'beerId': int.parse(cartItem.beer!.beerId) },

        );
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Hero(
                tag: "beer-"+cartItem.beer!.beerId,
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
                        Text(cartItem.beer!.name!, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0), textAlign: TextAlign.left),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                              context,
                              "/brewery",
                              arguments: { 'breweryId': int.parse(cartItem.beer!.breweryId!) },

                            );
                          },
                          child: new Row(
                            children: <Widget>[
                              Image.network( cartItem.beer!.breweryImage! ,
                                height: 15,
                                fit: BoxFit.fill,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: new Text(
                                  cartItem.beer!.breweryName!,
                                  style: TextStyle(fontSize:14 ,color: SECONDARY_TEXT_DARK.withOpacity(1)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 5,),

                        /*
                        Text(cartItem.beer!.type.toString() ,
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.left
                        ),


                        Text( "ABV: " + cartItem.beer!.abv.toString() + ". IBU: " + cartItem.beer!.ibu.toString()  ,
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.left
                        ),

                         */

                        CounterSelector(
                            counterInitCount: cartItem.itemCount,
                            counterPadding: EdgeInsets.only(left:0, top: 12.0, right: 12.0, bottom:12.0),
                            color: cartItem.beer!.rgbColor,
                            notifyParent: (int items){
                              // setState( () => _itemsCount = items );
                              if(cartItem.itemCount<items){
                                cart.modifyAmount(cartItem, "increase");
                              }else{
                                cart.modifyAmount(cartItem, "decrease");
                              }


                            }
                        ),
                      ]
                  ),
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            "\$" + cartItem.itemPrice.round().toString(),
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),

                    SizedBox(height: 3,),

                    Consumer<Cart>(
                      builder: (context, cart, child){
                        return InkWell(
                          onTap: (){
                            cart.remove(cartItem);
                          },
                            child: Row(
                              children: [
                                Icon(Icons.close, color: Colors.red,),
                                SizedBox(width: 2,),
                                Text("Remover", style: TextStyle(color: Colors.red)),
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
      ),
    );
  }

  Widget _buildCheckoutButton(){
    // MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(Colors.white.withOpacity(.8));
    MaterialStateProperty<Color?>? backgroundColor = MaterialStateProperty.all<Color>(SECONDARY_BUTTON_COLOR.withOpacity(.65));
    return AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      height: 80,
      padding: EdgeInsets.only( bottom: 5 ),
      decoration: BoxDecoration( gradient: PRIMARY_GRADIENT_COLOR,),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
        child: SizedBox(
          width: double.infinity,
          child: Consumer<Cart>(
            builder: (context, cart, child){
              return (cart.items.length > 0 ? ElevatedButton(

                onPressed: () => null,
                child: Text(
                    "Finalizar compra " + "(\$" + cart.finalPrice().round().toString() + ")",
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

    return Scaffold(
      bottomNavigationBar: _buildCheckoutButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child: Consumer<Cart>(
                  builder: (context, cart, child){

                    //print("Cart items: " + cart.items.length.toString());
                    List<Widget> cartItemsList = [];
                    for(var i = 0; i < cart.items.length; i++){
                      cartItemsList.add( _buildCartItem(cart.items[i], cart));
                    }
                    //cartItemsList.add(SizedBox(height: 90,));
                    // print(cartItemsList.length.toString());
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      // padding: EdgeInsets.only(top: 50),
                      height: MediaQuery.of(context).size.height - 100,
                      child: SingleChildScrollView(
                        child: (
                            cartItemsList.length > 0
                                ? Padding(
                                  padding: const EdgeInsets.only(bottom: 90.0),
                                  child: Column( children: cartItemsList,),
                                )
                                : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
                                  child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                  SizedBox(height: 50,),
                                  Image.asset("assets/images/loudly-crying-face_1f62d.png", height: 45,),
                                  SizedBox(height: 10,),
                                  Center(child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: "Tu carrito ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                        TextSpan(text: "está vacío.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))
                                      ]
                                    ),
                                  ),),
                                  SizedBox(height: 10,),
                                  Center(child: RichText(
                                    text: TextSpan(text: "Incluye tus productos ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                  ),),
                                  Center(child: RichText(
                                    text: TextSpan(text: "a través de la compra", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                  ),),
                                  Center(child: RichText(
                                    text: TextSpan(text: "inmediata.", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                  ),),

                              SizedBox(height: 10,),

                              ElevatedButton(
                                onPressed: (){

                                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                },
                                child: Wrap(
                                    spacing: 4.0,
                                    children: [
                                      Icon(Icons.sports_bar),
                                      Padding(
                                        padding: const EdgeInsets.only(top:4),
                                        child: Text("¡Descubrir cevezas ahora!"),
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

                              ],
                            ),
                                )
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
        title: Text("Carrito"),
        elevation: 0,
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
      ),
    );
  }
}