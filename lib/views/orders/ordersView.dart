import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/models/login.dart';

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
  void initState(){
    _customerOrders = getOrders();

  }

  Future<List<dynamic>?> getOrders() async {
    _userData =  await SharedServices.loginDetails();
    return await WordpressAPI.getOrders(_userData!.data!.id);
  }

  Widget _buildSingleOrderBox(Map<String, dynamic> order){

    String finalStatus = order["status"];
    late IconData finalIcon;
    late Color finalColor;
    if (order["status"] == "pending"){
      finalStatus = "Procesando";
      finalIcon = Icons.hourglass_top;
      finalColor = Colors.redAccent.withOpacity(0.8);
    }
    if (order["status"] == "completed"){
      finalStatus = "Completado";
      finalIcon = Icons.check_circle;
      finalColor = Colors.green.withOpacity(0.8);
    }
    if (order["status"] == "processing"){
      finalStatus = "En camino";
      finalIcon = Icons.delivery_dining;
      finalColor = Colors.blue.withOpacity(0.8);
    }
    if (order["status"] == "cancelled"){
      finalStatus = "Cancelado";
      finalIcon = Icons.cancel;
      finalColor = Colors.black.withOpacity(0.8);
    }


    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[

            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pedido #" + order["id"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left),
                          SizedBox(height: 3,),

                          Row(
                            children: [
                              Text(
                                  "Fecha: ",
                                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.2),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.left
                              ),
                              Text(
                                order["date_created"].toString().replaceAll("T", " "),
                                style: TextStyle(fontSize: 13, ),
                              )
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                  "Pago: ",
                                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.2),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.left
                              ),
                              Text(
                                order["payment_method_title"].toString(),
                                style: TextStyle(fontSize: 13, ),
                              )
                            ],
                          ),

                          SizedBox(height: 5,),

                          Row(
                            children: [
                              Icon(Icons.sports_bar, size: 20, color: Colors.black,) ,
                              SizedBox(width: 5,),
                              Text(order["line_items"].length.toString() + " " + "cerveza(s)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.left),

                            ],
                          ),

                          Row(
                            children: [
                              Icon(Icons.paid, size: 20, color: Colors.black,) ,
                              SizedBox(width: 5,),
                              Text("\$" + order["total"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.left),

                            ],
                          ),

                        ]
                    ),


                    Positioned(
                      top: -5,
                      right: 5,
                      child: Chip(
                        backgroundColor: finalColor,
                        avatar: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(finalIcon, color: finalColor,)
                        ),
                        label: Text(
                          finalStatus,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        ),
                      )
                    ),

                  ],


                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildOrderBoxes(List ordersList){
    List<Widget> ordersFinalList = [];
    for(var i = 0; i < ordersList.length; i++){
      ordersFinalList.add(
          _buildSingleOrderBox(ordersList[i])
      );
    }
    return Column(
        children: ordersFinalList
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),

         */
        title: Text("Pedidos realizados"),
        //elevation: 0,
      ),
      // bottomNavigationBar: _buildFinishCheckoutButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR
            ),
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: double.infinity, maxHeight: double.infinity),
            child: FutureBuilder(
              future: _customerOrders,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,),
                      ],
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      print("DATA: " + snapshot.data.toString());
                      if (snapshot.data.length > 0){
                        return _buildOrderBoxes(snapshot.data);
                      }else{
                        return Padding(
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
                                      // TextSpan(text: "No hay ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                                      TextSpan(text: "No hay pedidos.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))
                                    ]
                                ),
                              ),),
                              SizedBox(height: 10,),
                              Center(child: RichText(
                                text: TextSpan(text: "Incluye tus cervezas ", style: TextStyle(fontSize: 20, color: Colors.black87)),
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
                        );
                      }

                    }
                }
              }
            ),
          ),
        )
      ),
    );
  }
}
