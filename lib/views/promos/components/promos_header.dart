import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/helpers.dart';
import 'package:Hops/components/score_button.dart';
import 'package:Hops/components/app_title.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';

import 'package:Hops/components/score_mini_button.dart';

class PromosHeader extends StatefulWidget {
  const PromosHeader({Key? key}) : super(key: key);

  @override
  State<PromosHeader> createState() => _PromosHeaderState();
}

class _PromosHeaderState extends State<PromosHeader> {
  Future? _userScore;
  String _scoreOverview = "";

  @override
  void initState() {
    super.initState();
    //_breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
    _userScore = getUserScore();
    // _discoverBeers = DiscoverBeers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Provider.of<Loader>(context, listen: false).setLoading(true);
      // now i need to check that all loadings are done
    });
  }

  Future getUserScore() async {
    var userData = await SharedServices.loginDetails();
    return WordpressAPI.getUserPrefs(userData!.data!.id, indexType: "score");
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      AppTitle(
        title: "Promos",
        horizontalPadding: 25.0,
      ),
      Padding(
        padding: const EdgeInsets.only(right: marginSide),
        child: FutureBuilder(
            future: _userScore,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                      width: 5,
                      height: 5,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.black,
                      ));
                default:
                  if (snapshot.hasError) {
                    return Text(' Ups! Errors: ${snapshot.error}');
                  } else {
                    _scoreOverview = snapshot.data["result"].toString();
                    print(_scoreOverview);
                    return ScoreMiniButton(
                      text: _scoreOverview,
                      image: Image.asset(
                        "assets/images/medal.png",
                        height: 20,
                      ),
                      press: () {
                        Helpers.launchURL(
                            "https://hops.uy/revista/novedades/como-funciona-hops/");
                      },
                    );
                  }
              }
            }),
      ),
    ]);
  }
}
