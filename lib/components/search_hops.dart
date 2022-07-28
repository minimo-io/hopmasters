import 'package:Hops/helpers.dart';
import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/wordpress_api.dart';

class SearchHops extends SearchDelegate {
  SearchHops() : super(searchFieldLabel: "Buscar...");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
          decoration: const BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child:
              const Center(child: Text("¡Encuentra cervezas y cervecerías!")));
    } else {
      if (query.length < 3)
        return Container(
            decoration: BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child: Center(
                child: Text(
                    "Escribe al menos 3 caracteres para iniciar la búsqueda.")));

      return FutureBuilder(
          future: WordpressAPI.search(query: query),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: PRIMARY_GRADIENT_COLOR,
                  ),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Map result = snapshot.data[index];
                        String postSubtype = result["subtype"];
                        bool openOnApp = result["data"]["openOnApp"];

                        // switch (postSubtype) {
                        //   case "product":

                        //     openOnApp = true;
                        //     break;
                        //   case "page":
                        //     resultTitle = result["title"];
                        //     openOnApp = true;
                        //     break;
                        //   default:
                        //     openOnApp = false;
                        //     resultTitle = result["title"];
                        //   /*
                        //   case "tiendas":
                        //   case "locales":
                        //   case "bares":
                        //   case "promos":
                        //   */
                        //}

                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Text(result["title"]),
                              subtitle:
                                  Text(result["data"]["convertedPostType"]),
                              leading: Image.network(result["data"]["image"]),
                              dense: true,
                              onTap: () {
                                if (openOnApp) {
                                  if (postSubtype == "product") {
                                    Navigator.pushNamed(
                                      context,
                                      "/beer",
                                      arguments: {'beerId': result["id"]},
                                    );
                                  } else if (postSubtype == "page") {
                                    Navigator.pushNamed(
                                      context,
                                      "/brewery",
                                      arguments: {'breweryId': result["id"]},
                                    );
                                  }
                                } else {
                                  Helpers.launchURL(siteUrl +
                                      "/?p=" +
                                      result["id"].toString());
                                }
                              },
                            ),
                          ],
                        );
                      }),
                );
              } else {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: PRIMARY_GRADIENT_COLOR,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          "assets/images/loudly-crying-face_1f62d.png",
                          height: 45,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              // TextSpan(text: "Tu carrito ", style: TextStyle(fontSize: 20, color: Colors.black87)),
                              TextSpan(
                                  text: "No se encontraron resultados.",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87))
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                                text: "Intenta mejorar tu búsqueda de",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black87)),
                          ),
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                                text: "cervezas y cervecerías.",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black87)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Container(
                  decoration: const BoxDecoration(
                    gradient: PRIMARY_GRADIENT_COLOR,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: PROGRESS_INDICATOR_COLOR,
                      strokeWidth: 1.0,
                    ),
                  ));
            }
          });
    }
  }
}
