import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:provider/provider.dart';
import 'package:Hops/models/nav_menu_provider.dart';

class StoreView extends StatelessWidget {
  const StoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: Column(
            children: [
              const SizedBox(height: (30)),
              Row(
                children: [
                  Consumer<NavMenuProvider>(builder: (context, menu, child) {
                    return Container(
                        child: Center(
                            child: Text("Current index: " +
                                menu.currentIndex.toString())));
                  }),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height),
            ],
          ),
        ),
      ),
    );
  }
}
