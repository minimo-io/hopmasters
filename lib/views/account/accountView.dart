import 'package:Hops/models/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:Hops/constants.dart';
import 'package:Hops/services/facebook_signin.dart';
// import 'package:Hops/services/google_signin.dart';
import 'package:Hops/services/shared_services.dart';
import 'package:Hops/theme/style.dart';

import '../../helpers.dart';
import 'components/account_profile_pic.dart';
import '../../components/profile_menu.dart';

import 'package:Hops/utils/notifications.dart';

import 'package:Hops/services/shared_services.dart';
import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/models/login.dart';

class AccountView extends StatefulWidget {
  final String? userID;
  const AccountView({Key? key, this.userID}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with AutomaticKeepAliveClientMixin {
  Future<LoginResponse?>? _userData;

  LoginResponse? _userData2;
  late Future<List<dynamic>?> _customerOrders;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //SharedServices.logout(context);
    _userData = SharedServices.loginDetails();

    _customerOrders = getOrders();
  }

  Future<List<dynamic>?> getOrders() async {
    _userData2 = await SharedServices.loginDetails();
    return await WordpressAPI.getOrders(_userData2!.data!.id,
        status: "pending, processing, on-hold");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _userData = SharedServices.loginDetails();
            _customerOrders = getOrders();
          });
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: PRIMARY_GRADIENT_COLOR,
            ),
            child: FutureBuilder(
                future: Future.wait([
                  SharedServices.loginDetails(),
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                          child: CircularProgressIndicator(
                              color: PROGRESS_INDICATOR_COLOR));
                    default:
                      if (snapshot.hasError) {
                        return Text(' Ups! Errors: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            BreweryProfilePic(
                                key: UniqueKey(),
                                avatarUrl: snapshot.data[0].data.avatarUrl,
                                userId: snapshot.data[0].data.id),
                            const SizedBox(height: 20),

                            ProfileMenu(
                              text: "Mis pedidos",
                              icon: const Icon(Icons.shopping_cart),
                              press: () {
                                Navigator.pushNamed(context, "orders");
                              },
                              counterWidget: FutureBuilder(
                                  future: _customerOrders,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: PROGRESS_INDICATOR_COLOR,
                                                strokeWidth: 1.0,
                                              ))),
                                        );
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                              ' Ups! Errors: ${snapshot.error}');
                                        } else {
                                          return (snapshot.data.length > 0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 1.5,
                                                              color: Colors
                                                                  .white)),
                                                      child: Center(
                                                          child: Text(
                                                              snapshot
                                                                  .data.length
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 11,
                                                                  height: 1,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)))),
                                                )
                                              : Container());
                                        }
                                    }
                                  }),
                            ),

                            ProfileMenu(
                              text: "Experiencias",
                              icon: const Icon(Icons.place),
                              press: () {
                                Navigator.pushNamed(context, "experiences");
                              },
                            ),

                            ProfileMenu(
                              text: "Ayuda",
                              icon: const Icon(Icons.help_outline),
                              press: () {
                                Helpers.userAskedForHelp();
                              },
                            ),

                            /*
                          ProfileMenu(
                            text: "Notificaciones",
                            icon: Icon(Icons.notifications),
                            press: () {},
                          ),

                           */
                            // ProfileMenu(
                            //   text: "Preferencias",
                            //   icon: Icon(Icons.settings),
                            //   press: () {
                            //     Navigator.pushNamed(
                            //       context,
                            //       "preferences",
                            //       arguments: {'fromMainApp': true},
                            //     );
                            //   },
                            // ),

                            ProfileMenu(
                              text: "Mi perfil",
                              icon: const Icon(Icons.verified_user),
                              press: () {
                                var notificationClient = HopsNotifications();
                                notificationClient.message(
                                    context, "¡En próximas versiones!");
                              },
                            ),
                            ProfileMenu(
                              text: "Acerca de Hops",
                              icon: const Icon(Icons.help_center),
                              press: () {
                                showAboutDialog(
                                  context: context,
                                  // applicationVersion: snapshot.data.toString(),
                                  applicationIcon: MyAppIcon(),
                                  applicationLegalese:
                                      'Esta es una aplicación pensada para mayores de 18 años.',
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text(
                                          '¡Gracias por descargarte Hops! Estamos pleno desarrollo mejorando la app para apoyar a la comunidad de cervecera artesanal ¡Unite a lo local!'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            ProfileMenu(
                              text: "Salir",
                              icon: const Icon(Icons.logout),
                              press: () {
                                SharedServices.loginDetails()
                                    .then((loginPrefs) {
                                  SharedServices.logout(context);
                                  // if (loginPrefs!.data!.connectionType ==
                                  //     "Google") {
                                  //   Google googleService = new Google();
                                  //   googleService.logout().then((value) =>
                                  //       SharedServices.logout(context));
                                  // } else
                                  if (loginPrefs!.data != null &&
                                      loginPrefs.data!.connectionType ==
                                          "Facebook") {
                                    Facebook facebookService = Facebook();

                                    facebookService.logout(() {
                                      print("Facebook Logout OK");
                                    });
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 150),
                          ],
                        );
                      }
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class MyAppIcon extends StatelessWidget {
  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: size,
          height: size,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
