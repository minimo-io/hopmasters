import 'package:Hops/models/order_data.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class OrderDetailsBox extends StatefulWidget {
  Function()? onChangeShippingDetails;
  OrderData? lastOrder;

  OrderDetailsBox(
      {required this.lastOrder, this.onChangeShippingDetails, Key? key})
      : super(key: key);

  @override
  State<OrderDetailsBox> createState() => _OrderDetailsBoxState();
}

class _OrderDetailsBoxState extends State<OrderDetailsBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.lastOrder != null) {
      return InkWell(
        onTap: widget.onChangeShippingDetails,
        child: Card(
            elevation: .5,
            color: Colors.white,
            //color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 10.0, left: 15, right: 1),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Badge(
                        elevation: 0,
                        position: BadgePosition.topEnd(top: 0, end: 3),
                        animationDuration: const Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        toAnimate: true,
                        shape: BadgeShape.circle,
                        borderRadius: BorderRadius.circular(20),
                        badgeColor: Colors.transparent,
                        badgeContent: const Icon(
                          Icons.expand_more,
                          size: 15,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.place,
                          size: 18,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (widget.lastOrder!.address1 != null
                                            ? widget.lastOrder!.address1
                                            : "")! +
                                        ", " +
                                        (widget.lastOrder!.address2 != null
                                            ? widget.lastOrder!.address2
                                            : "")!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    //overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.lastOrder!.firstName! +
                                        " " +
                                        widget.lastOrder!.lastName!,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(widget.lastOrder!.telephone!,
                                          style:
                                              const TextStyle(fontSize: 12.0)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Cambiar",
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 1.0)),
                              // TextButton(
                              //     onPressed: widget.onChangeShippingDetails,
                              //     style: ButtonStyle(
                              //         padding: MaterialStateProperty.all(
                              //             EdgeInsets.all(0.0))),
                              //     child: const Text("Cambiar",
                              //         style: TextStyle(
                              //             color: Colors.redAccent,
                              //             fontSize: 10.0))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ))),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: widget.onChangeShippingDetails,
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(.2),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.black.withOpacity(.5)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(.7)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black.withOpacity(.1)),
                ))),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.place, size: 16.0),
                  const SizedBox(
                    width: 5.0,
                  ),
                  const Text(
                    "Agregar datos de envío",
                    style: TextStyle(fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
