import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:Hops/models/cart.dart';
// import 'package:Hops/components/qr_scanner.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      bottomOpacity: 0.0,
      elevation: 0.0,
      /*
      leading: Padding(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 0),
          child:BackButton(
          color: colorScheme.secondary
      )),
      */
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
      ),
      iconTheme: IconThemeData(color: colorScheme.secondary),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6.0, 0, 8.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/hops-logo.png',
              width: 25,
            ),
            SizedBox(
              width: 5,
            ),
            Container(
                child: Text(APP_TITLE,
                    style: GoogleFonts.russoOne(
                        textStyle: TextStyle(color: colorScheme.secondary)))),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0),
          child: InkWell(
            onTap: () {
              print("Scan beer!");
              /*
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QRViewExample(),
              ));
              */
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'En próximas versiones vas a poder comprar con Hops via QR en bares y acceder a descuentos y beneficios.')),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("ESCANEAR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black))
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 3.0, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Carrito',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/cart",
                    arguments: {'name': "Maracuyipas", "count": 125},
                  );
                },
              ),
            ),
            Consumer<Cart>(builder: (context, cart, child) {
              return (cart.items.length > 0
                  ? Positioned(
                      right: 0,
                      top: 20,
                      child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1.5, color: Colors.white)),
                          child: Center(
                              child: Text(cart.itemsCount.toString(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      height: 1,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)))),
                    )
                  : Container());
            }),

            //Consumer<Cart>(
            //   builder: (context, cart, child){
          ],
        ),
        SizedBox(
          width: 10,
        ),
        /*
        Stack(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 18.0, 6.0, 0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  tooltip: 'Notificaciones',
                  onPressed: () {
                    print("OHH BOY MENU");
                  },
                ),
              ),
              Positioned(
                right:15,
                top:20,
                child: Container(
                    height: 18,
                    width:18,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.white)
                    ),
                    child: Center(child: Text("4", style: TextStyle(fontSize: 11, height: 1, color: Colors.white, fontWeight: FontWeight.w600)))
                ),
              )
            ]
        )

         */
      ],
    );
  }
}
