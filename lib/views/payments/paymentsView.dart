import 'package:Hops/components/card_horizontal.dart';
import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

import '../../components/async_loader.dart';
import '../../models/payment.dart';
import '../../services/wordpress_api.dart';

class PaymentsView extends StatefulWidget {
  static const String routeName = "/payments";
  const PaymentsView({Key? key}) : super(key: key);

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  //LoginResponse? _userData;
  late Future<List<dynamic>?> _paymentGateways;

  @override
  void initState() {
    super.initState();
    _paymentGateways = getPayments();
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

  Future<List<dynamic>?> getPayments() async {
    //_userData =  await SharedServices.loginDetails();
    return await WordpressAPI.getPayments();
  }

  List<Widget> _buildPaymentsBox(List<Payment> payments) {
    List<Widget> paymentsList = [];
    for (int i = 0; i < payments.length; i++) {
      if (payments[i].enabled == false) continue;

      void Function()? paymentTap;
      if (payments[i].id == "bacs" || payments[i].id == "cod")
        paymentTap = () {
          Navigator.pop(context, payments[i]);
        };

      paymentsList.add(CardHorizontal(
          text: payments[i].title,
          useChevron: true,
          elevation: 1.0,
          padding: 20.0,
          icon: Icon(
            payments[i].icon,
            size: 20,
          ),
          onTap: paymentTap));
    }
    return paymentsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        title:
            const Text("Formas de pago", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _paymentGateways = getPayments();
            });
          },
          child: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: marginSide, vertical: 20.0),
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height - kToolbarHeight,
                ),
                decoration: const BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: FutureBuilder(
                  future: _paymentGateways,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1.0,
                            ),
                          ],
                        );
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Payment> payments =
                              Payment.allFromResponse(snapshot.data);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _buildPaymentsBox(payments),
                          );
                        }
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }
}
