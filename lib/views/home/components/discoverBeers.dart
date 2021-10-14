import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/beer_cards.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class DiscoverBeers extends StatefulWidget {
  const DiscoverBeers({Key? key}) : super(key: key);

  @override
  _DiscoverBeersState createState() => _DiscoverBeersState();
}

class _DiscoverBeersState extends State<DiscoverBeers> {
  Future? _beers;
  String _disoverBeersType = "recent";

  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  List _selectedAnimals = [];

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      builder: (ctx) {
        return  MultiSelectDialog(
          items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
          initialValue: _selectedAnimals,
          onConfirm: (values) {
            _selectedAnimals = values;
          },
        );
      },
    );
  }

  Widget _discoverBeersHeader(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: marginSide),
      child: Padding(
        /*padding: const EdgeInsets.only(top: 8.0),*/
        padding:const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Descubrir',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    color: colorScheme.secondary,
                  ),
                ),
                InkWell(
                  onTap: () {

                    Scaffold.of(context)
                        .showBottomSheet<void>(
                          (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height:  430,
                            color: Colors.white,
                            child: Container(
                              // height: (widget.height != null ? widget.height : 430),
                              height: (430),
                              color: Colors.white,
                              child: ListView(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 20, top: 20),
                                      height: 50,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "FILTRAR",
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 30,),
                                  /*
                            Divider(
                              thickness: 1,
                            ),
                            */
                                  // direct buy

                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: ElevatedButton(
                                              onPressed: (){
                                                print("OK");
                                              },

                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      //mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Icon(Icons.bolt, size: 35, color: Colors.amber),
                                                          SizedBox(width: 8,),
                                                          // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                                          Text( "Con compra inmediata" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                                        ]
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )



                                  ),
                                  SizedBox(height: 7,),


                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showMultiSelect(context);

                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.sports_bar, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Por tipos de cervezas" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                  MultiSelectChipDisplay(
                                    items: _selectedAnimals.map((e) => MultiSelectItem(e, e)).toList(),
                                    //items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
                                    onTap: (value) {
                                      setState(() {
                                        _selectedAnimals.remove(value);
                                      });
                                    },
                                  ),

                                  SizedBox(height: 5)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      elevation: 25,
                    )
                        .closed
                        .whenComplete(() {

                    });

                  },
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.black26,),
                      Text(
                        "Mas filtros",
                        style: TextStyle(color: BUTTONS_TEXT_DARK),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _disconverBeersCategories(){
    return Container(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryButton(
                text: "Novedades",
                icon: Icons.schedule,
                color: Colors.white,
                isSelected: true,
                onPressedAction: (){
                  setState(() {
                    _disoverBeersType = "recent";
                    _beers = WordpressAPI.getBeers(type: "recent");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Mas votadas",
                icon: Icons.star,
                color: Colors.amberAccent,
                onPressedAction: (){
                  setState(() {
                    _disoverBeersType = "most_voted";
                    _beers = WordpressAPI.getBeers(type: "most_voted");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Tendencia",
                icon: Icons.local_fire_department,
                color: Colors.red,
                onPressedAction: (){
                  setState(() {
                    _disoverBeersType = "trends";
                    _beers = WordpressAPI.getBeers(type: "trends");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Premium",
                icon: Icons.verified,
                color: Color.fromRGBO(25, 119, 227, 1),
                onPressedAction: (){
                  setState(() {
                    _disoverBeersType = "premium";
                    _beers = WordpressAPI.getBeers(type: "premium");
                  });
                }
            )
          ],
        )
    );
  }

  Widget _buildButtonText({ String text = "" }){
    return Text(text, style: TextStyle(fontSize: 15, color: BUTTONS_TEXT_DARK));
  }

  Widget _buildCategoryButton({
    String text = "",
    IconData? icon,
    Color color = Colors.black87,
    Color backgroundColor = Colors.black,
    bool isSelected = false,
    VoidCallback? onPressedAction
  }){
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ElevatedButton(

            onPressed: onPressedAction,
            child: Icon(icon, color: color, size: 25,),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
                /*
                foregroundColor: MaterialStateProperty
                    .all<Color>(
                    Colors.black.withOpacity(
                        .6)),
                 */
                backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
                shape: MaterialStateProperty
                    .all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .circular(20.0),
                        side: BorderSide(
                            width: .8,
                            color: Colors.black.withOpacity(.2))
                    )
                )
            ),
          ),
        ),
        _buildButtonText(text: text)
      ],
    );
  }

  Widget _buildListGridView(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /*
          OutlinedButton(
            onPressed: () {
              print('Received click');
            },
            child: Row(
              children: [
                Icon(Icons.grid_view_sharp, color: Colors.black, size: 17,),
                SizedBox(width: 4,),
                Text("Grilla", style: TextStyle( color: Colors.black ),)
              ],
            ),
          ),

          SizedBox(width: 5,),

          OutlinedButton(
            onPressed: () {
              print('Received click');
            },
            child: Row(
              children: [
                Icon(Icons.view_list_outlined, color: BUTTONS_TEXT_DARK, size: 21,),
                SizedBox(width: 4,),
                Text("Lista", style: TextStyle( color: BUTTONS_TEXT_DARK ),)
              ],
            ),
          ),

           */
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_beers = WordpressAPI.getBeersFromBreweryID("89107");
    _beers = WordpressAPI.getBeers(type: _disoverBeersType);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(height: 10,),

        _discoverBeersHeader(),
        SizedBox(height: 15,),

        _disconverBeersCategories(),

        SizedBox(height: 15,),


        FutureBuilder(
            future: _beers,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center( child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,) );
                default:
                  if (snapshot.hasError){
                    return Text('Ups! Error: ${snapshot.error}');
                  }else{
                    return Column(
                      children: [
                        _buildListGridView(),
                        SizedBox(height: 10,),
                        BeerCards( beersList: snapshot.data, discoverBeersType: _disoverBeersType,),

                      ],
                    );
                  }
              }
            }
        ),
        /*
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: beerStyles.length,
            itemBuilder: (_, index) => Padding(
              padding: index == 0
                  ? const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4)
                  : const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 4),
              child: Text(
                beerStyles[index],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: index == 0 ? colorScheme.secondary : colorScheme.secondary.withOpacity(0.5)  ,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),

         */
      ],

    );
  }
}
