import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';

class ExperiencesView extends StatefulWidget {
  static const String routeName = "experiences";
  const ExperiencesView({Key? key}) : super(key: key);

  @override
  State<ExperiencesView> createState() => _ExperiencesViewState();
}

class _ExperiencesViewState extends State<ExperiencesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: PRIMARY_GRADIENT_COLOR),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        title:
            const Text("Experiencias", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              // _userData = SharedServices.loginDetails();
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
                      const SizedBox(
                        height: 120,
                      ),
                      Image.asset(
                        "assets/images/loudly-crying-face_1f62d.png",
                        height: 45,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "En construcción.",
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
                                  "En el futuro podrás comprar tus ingresos a ",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                              text: "festivales, eventos y paseos, además de",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                              text:
                                  "administrar tus suscripciones a los clubes.",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Helpers.launchURL("https://hops.uy/revista/turismo/");
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(.6)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white.withOpacity(.8)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.black.withOpacity(.2)),
                            ))),
                        child: const Text("Ver en la web por ahora"),
                      ),
                      const SizedBox(
                        height: 600,
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
