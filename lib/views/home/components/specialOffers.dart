import 'package:flutter/material.dart';
import 'package:Hops/helpers.dart';
import 'sectionTitle.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: (20)),
          child: SectionTitle(
            title: "Especiales para vos",
            press: () { print("Especiales para vos"); },
          ),
        ),
        SizedBox(height: (20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/Beer_Banner_3.png",
                category: "¿Cómo funciona?",
                subtitle: "Mira la idea detrás de HOPS",
                press: () {
                  Helpers.launchURL("https://hops.uy/revista/novedades/como-funciona-hops/");
                },
              ),
              SpecialOfferCard(
                image: "assets/images/Beer_Banner_5.png",
                category: "Cerveza destacada",
                subtitle: "Maracuyipa de Oso Pardo",
                press: () {
                  Navigator.pushNamed(
                    context,
                    "/beer",
                    arguments: { 'beerId': 89342 },

                  );
                },
              ),

              SizedBox(width: (20)),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.subtitle,
    required this.press,
  }) : super(key: key);

  final String category, image, subtitle;
  //final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: (242),
          height: (100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (15.0),
                    vertical: (10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: (18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$subtitle")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}