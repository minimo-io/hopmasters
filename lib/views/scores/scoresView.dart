import 'package:Hops/components/help_action_button.dart';
import 'package:Hops/components/hops_alert.dart';
import 'package:Hops/components/score_button.dart';
import 'package:Hops/components/table.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class ScoresView extends StatefulWidget {
  static const String routeName = "scores";
  const ScoresView({Key? key}) : super(key: key);

  @override
  State<ScoresView> createState() => _ScoresViewState();
}

class _ScoresViewState extends State<ScoresView> {
  Future? _userScore;
  String _scoreOverview = "";

  @override
  void initState() {
    super.initState();
    _userScore = getUserScore();
  }

  Future getUserScore() async {
    var userData = await SharedServices.loginDetails();
    return WordpressAPI.getUserPrefs(userData!.data!.id, indexType: "score");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Puntos", style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: const [
          HelpActionButton(),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _userScore = getUserScore();
            });
          },
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
                      // const SizedBox(
                      //   height: marginSide,
                      // ),
                      // AppTitle(title: "Promos"),
                      //const PromosHeader(),
                      FutureBuilder(
                          future: _userScore,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return ScoreButton(
                                  showDetailsButton: false,
                                  cardPadding: const EdgeInsets.symmetric(
                                      horizontal: appMarginSize),
                                  contrast: "low",
                                  score: 0,
                                  text: "Cargando puntaje...",
                                  image: Image.asset(
                                    "assets/images/medal.png",
                                    height: 20,
                                  ),
                                  press: () {},
                                );
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                      ' Ups! Errors: ${snapshot.error}');
                                } else {
                                  _scoreOverview =
                                      snapshot.data["result"].toString();
                                  if (_scoreOverview.isEmpty)
                                    _scoreOverview = "0";
                                  return ScoreButton(
                                    cardPadding: const EdgeInsets.symmetric(
                                        horizontal: appMarginSize),
                                    showDetailsButton: false,
                                    contrast: "low",
                                    score: int.parse(_scoreOverview),
                                    text: _scoreOverview +
                                        " punto" +
                                        (_scoreOverview != "1" ? "s" : "") +
                                        " canjeable" +
                                        (_scoreOverview != "1" ? "s" : ""),
                                    image: Image.asset(
                                      "assets/images/medal.png",
                                      height: 20,
                                    ),
                                    press: () => null,
                                  );
                                }
                            }
                          }),

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: appMarginSize),
                        child: HopsAlert(
                            text:
                                "Los Puntos HOPS se obtienen por interactuar con la app. Pueden ser canjeados por beneficios en los bares asociados (comprando via QR) o en la sección de Promos de la app.",
                            color: Colors.blueAccent,
                            icon: Icons.info),
                      ),
                      // const SizedBox(
                      //   height: 3.0,
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: marginSide),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              //elevation: cardsElevations,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HopsTable(
                                  title: "Detalles",
                                  rows: const [
                                    {
                                      'key': 'Comentario aprobado',
                                      'value': '+1 punto',
                                      'icon': Icons.chat,
                                    },
                                    {
                                      'key': 'Compra procesada',
                                      'value': '+10 puntos',
                                      'icon': Icons.shopping_cart,
                                    }
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 60,
                      ),
                      Image.asset(
                        inConstructionIcon,
                        height: 45,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "En construcción",
                                style: TextStyle(
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
                          text: const TextSpan(
                              text:
                                  "En próximas versiones verás aquí el detalle",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                              text: "de cómo has ganado y utilizado",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                              text: "tus Puntos Hops.",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 500,
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
