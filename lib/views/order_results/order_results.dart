import 'package:Hops/constants.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

class OrderResultsView extends StatelessWidget {
  static const String routeName = "/orderResults";
  final String results;
  final String payment;

  const OrderResultsView({this.results = "", this.payment = "cod", Key? key})
      : super(key: key);

  Map<String, dynamic> _resultTextParams(List results, bool errorFounded) {
    bool isPlural = false;
    if (results.length > 1) isPlural = true;

    if (errorFounded != true) {
      return {
        "icon": Icons.check_circle,
        "color": Colors.greenAccent,
        "textMain": "ÉXITO",
        "textLine1": "¡Pedido" +
            (isPlural ? "s" : "") +
            " realizado" +
            (isPlural ? "s" : "") +
            " exitosamente!",
        "textLine2": "Se procesará" +
            (isPlural ? "n" : "") +
            " una vez que realices el pago"
      };
    } else {
      return {
        "icon": Icons.error,
        "color": Colors.redAccent,
        "textMain": "¡UPS! PASÓ ALGO",
        "textLine1":
            (isPlural ? "Algunos pedidos podrían" : "Algún pedido podría"),
        "textLine2": "no haberse realizado"
      };
    }
  }

  bool _errorExists(List<String> results) {
    bool errorFounded = false;
    for (int i = 0; i < results.length; i++) {
      if (results[i] == "false") {
        // this comes as a String from param
        errorFounded = true;
        break;
      }
    }

    return errorFounded;
  }

  Widget _buildPaymentInfo(String payment, BuildContext context) {
    switch (payment) {
      case "bacs":
        const double bankDetailsFontSize = 12.0;
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text("Transferencia bancaria",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Cuenta",
                              style: TextStyle(
                                  fontSize: bankDetailsFontSize,
                                  color: Colors.grey)),
                          Text("001166629-00003")
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Titular",
                              style: TextStyle(
                                  fontSize: bankDetailsFontSize,
                                  color: Colors.grey)),
                          Text("Nicolas Erramuspe")
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Banco",
                              style: TextStyle(
                                  fontSize: bankDetailsFontSize,
                                  color: Colors.grey)),
                          Text("BROU")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                        "Recuerda que el envío sólo procesará una vez hayamos recibido la transaferencia bancaria. Puedes verificar el estado del pedido en la sección Mis Pedidos.",
                        style: TextStyle(fontSize: 10.0)),
                    //Text("", style: TextStyle(fontSize: 10.0)),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> resultsList =
        results.replaceAll("[", "").replaceAll("]", "").split(",");

    // resultsList.add("false"); // for testing the false state of thigs.
    bool error = _errorExists(resultsList);
    Map<String, dynamic> resultsInfo = _resultTextParams(resultsList, error);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("", style: TextStyle(color: Colors.black)),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
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
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Icon(
                        resultsInfo["icon"],
                        size: 55,
                        color: resultsInfo["color"],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: resultsInfo["textMain"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: resultsInfo["textLine1"],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87)),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: resultsInfo["textLine2"],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "orders");
                            },
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(.2)),
                                ))),
                            child: Text("Ver pedido" +
                                (resultsList.length > 1 ? "s" : "")),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName('/'));
                            },
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(.2)),
                                ))),
                            child: const Text("Volver a la app"),
                          ),
                        ],
                      ),
                      if (error)
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) + 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Helpers.userAskedForHelp();
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white.withOpacity(1)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent.withOpacity(.8)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(.2)),
                                ))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.help,
                                  size: 16.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Entrar en contacto"),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildPaymentInfo(payment, context),
                      const SizedBox(
                        height: 300,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
