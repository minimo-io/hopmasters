import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/beer_cards.dart';
import 'package:Hops/models/advanced_beer_filter.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:Hops/utils/notifications.dart';

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class DiscoverBeers extends StatefulWidget {

  const DiscoverBeers({
    Key? key
  }) : super(key: key);

  @override
  _DiscoverBeersState createState() => _DiscoverBeersState();
}

class _DiscoverBeersState extends State<DiscoverBeers> with AutomaticKeepAliveClientMixin {
  Future? _beers;
  String _disoverBeersType = "recent";
  String _disoverBeersTypeExtraParam = "";
  HopsNotifications notificationClient =  new HopsNotifications();

  @override
  bool get wantKeepAlive => true;

  static List<AdvacedBeerFilter> _moreFilters = [
    AdvacedBeerFilter(apiEndpoint: "ibu", extraParam: "high", icon: Icons.trending_up, iconColor: Colors.amber, name: "Mayor IBU", alert: "Existen cervezas sin valores de IBU público que puede quedar fuera de este ranking."),
    AdvacedBeerFilter(apiEndpoint: "ibu", extraParam: "low", icon: Icons.trending_down, iconColor: Colors.amber, name: "Mayor IBU", alert: "Existen cervezas sin valores de IBU público que puede quedar fuera de este ranking."),

  ];

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
  List _selectedBeers = [];
  List _selectedBeerFilters = [];

  void _showMultiSelect(BuildContext context, BuildContext oldContext) async {
    await showDialog(
      context: context,
      //barrierColor: Colors.white,
      useSafeArea: true,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.black)),
          child: MultiSelectDialog(
            backgroundColor: Colors.white.withOpacity(1),
            checkColor: Colors.black,
            cancelText: Text("Cancelar"),
            confirmText: Text("Buscar"),
            searchHint: "Buscar",
            title: Text("Tipos de cervezas"),
            searchable: true,
            items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
            initialValue: _selectedBeers,
            onConfirm: (values) {
              setState(() {
                _selectedBeers = values;
              });
              Navigator.of(context).pop();
              // call parent call back to re-launch the search with this special filter
              notificationClient.message(oldContext, "Esta función estará disponible en próximas versiones.");
            },
          ),
        );
      },
    );
  }

  Widget _discoverBeersHeader(){
    HopsNotifications notificationClient =  new HopsNotifications();



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

                    // more filters state on parent
                    //if (widget.notifyParent != null) widget.notifyParent!();

                    // create build
                    BuildContext oldContext = context;
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 25, top: 20),
                                          height: 50,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                "FILTRAR CERVEZAS",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                            ),
                                          )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.0, right:15.0),
                                        child: SizedBox(
                                          height: 37,
                                          child: ElevatedButton(

                                            onPressed: ()=> Navigator.pop(context),
                                            child: Text("Cerrar", style: TextStyle(fontSize: 12),),
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
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
                                      ),

                                    ],
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

                                          setState(() {
                                            _disoverBeersType = "premium";
                                            _beers = WordpressAPI.getBeers(type: "premium");
                                          });
                                          Navigator.of(context).pop();

                                          //notificationClient.message(oldContext, "Esta función estará disponible en próximas versiones.");
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.verified, size: 35, color: BUTTON_GREEN),
                                                    SizedBox(width: 8,),
                                                    // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                                    Text( "Con compra verificada" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                                  ]
                                              ),
                                            ],
                                          ),
                                        ),
                                      )



                                  ),


                                  /*
                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {

                                        setState(() {
                                          _selectedBeerFilters = [];
                                          _selectedBeerFilters = [
                                            AdvacedBeerFilter(
                                                apiEndpoint: "price",
                                                extraParam: "ASC",
                                                icon: Icons.money_off,
                                                iconColor: Colors.amber,
                                                name: "Más económicas")
                                          ];

                                          _disoverBeersType = "price";
                                          _disoverBeersTypeExtraParam = "ASC";
                                          _beers = WordpressAPI.getBeers(type: _disoverBeersType, extraParam1: _disoverBeersTypeExtraParam);
                                        });
                                        Navigator.of(context).pop();

                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.money_off, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Mas económicas" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),

                                  */

                                  /*
                                  SizedBox(height: 7,),

                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: ElevatedButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                          notificationClient.message(oldContext, "Esta función estará disponible en próximas versiones.");
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.military_tech, size: 35, color: Colors.amber),
                                                    SizedBox(width: 8,),
                                                    // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                                    Text( "Mas vendidas" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                                  ]
                                              ),
                                            ],
                                          ),
                                        ),
                                      )



                                  ),
                                   */


                                  SizedBox(height: 7,),



                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      /*
                                      onPressed: () {
                                        _showMultiSelect(context, oldContext);

                                      },
                                      */
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        notificationClient.message(oldContext, "Esta función estará disponible en la versión 2 de la app.");
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.sports_bar, size: 35, color: Colors.grey),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Por tipos de cervezas" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),


                                  /*
                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //_showMultiSelect(context);
                                        Navigator.of(context).pop();
                                        notificationClient.message(oldContext, "Esta función estará disponible en próximas versiones.");

                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.paid, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Mas costosas" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                  */

                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {

                                        // _showMultiSelect(context, oldContext);
                                        setState(() {
                                          _selectedBeerFilters = [];
                                          _selectedBeerFilters = [
                                            AdvacedBeerFilter(apiEndpoint: "abv", extraParam: "DESC", icon: Icons.liquor, iconColor: Colors.amber, name: "Mayor alcohól")
                                          ];

                                          _disoverBeersType = "abv";
                                          _disoverBeersTypeExtraParam = "DESC";
                                          _beers = WordpressAPI.getBeers(type: _disoverBeersType, extraParam1: _disoverBeersTypeExtraParam);
                                        });
                                        Navigator.of(context).pop();


                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.liquor, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Mayor alcohól" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {

                                        // _showMultiSelect(context, oldContext);
                                        setState(() {
                                          _selectedBeerFilters = [];
                                          _selectedBeerFilters = [
                                            AdvacedBeerFilter(apiEndpoint: "abv", extraParam: "ASC", icon: Icons.local_bar, iconColor: Colors.amber, name: "Menor alcohól")
                                          ];

                                          _disoverBeersType = "abv";
                                          _disoverBeersTypeExtraParam = "ASC";
                                          _beers = WordpressAPI.getBeers(type: _disoverBeersType, extraParam1: _disoverBeersTypeExtraParam);
                                        });
                                        Navigator.of(context).pop();


                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.local_bar, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Menor alcohól" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {

                                        // _showMultiSelect(context, oldContext);
                                        setState(() {
                                          _selectedBeerFilters = [];
                                          _selectedBeerFilters = [
                                            AdvacedBeerFilter(apiEndpoint: "ibu", extraParam: "high", icon: Icons.trending_up, iconColor: Colors.amber, name: "Mayor IBU", alert: "Existen cervezas sin valores de IBU público que puede quedar fuera de este ranking.")
                                          ];

                                          _disoverBeersType = "ibu";
                                          _disoverBeersTypeExtraParam = "high";
                                          _beers = WordpressAPI.getBeers(type: _disoverBeersType, extraParam1: _disoverBeersTypeExtraParam);
                                        });
                                        Navigator.of(context).pop();

                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.trending_up, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Mayor IBU" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 7,),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.95,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {

                                        setState(() {
                                          _selectedBeerFilters = [];
                                          _selectedBeerFilters = [
                                            AdvacedBeerFilter(apiEndpoint: "ibu", extraParam: "low", icon: Icons.trending_up, iconColor: Colors.amber, name: "Menor IBU", alert: "Existen cervezas sin valores de IBU público que puede quedar fuera de este ranking.")
                                          ];

                                          _disoverBeersType = "ibu";
                                          _disoverBeersTypeExtraParam = "low";
                                          _beers = WordpressAPI.getBeers(type: _disoverBeersType, extraParam1: _disoverBeersTypeExtraParam);
                                        });
                                        Navigator.of(context).pop();


                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //Image.asset("assets/images/icons/whatsapp-logo-2.png", height: 35, width: 35,),
                                              Icon(Icons.trending_down, size: 35, color: Colors.amber),
                                              SizedBox(width: 8,),
                                              // Text( widget.beer.breweryWhatsapp, style: TextStyle(fontSize: 18, color: Colors.black54),)
                                              Text( "Menor IBU" , style: TextStyle(fontSize: 20, color: Colors.black54),)
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),


                                  SizedBox(height: 20)
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
                        "Más filtros",
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
                text: "Nuevas",
                icon: Icons.schedule,
                color: Colors.white,
                isSelected: (_disoverBeersType == "recent" ? true : false ),
                onPressedAction: (){
                  setState(() {
                    _selectedBeerFilters = [];
                    _disoverBeersType = "recent";
                    _beers = WordpressAPI.getBeers(type: "recent");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Más Votadas",
                isSelected: (_disoverBeersType == "most_voted" ? true : false ),
                icon: Icons.star,
                color: Colors.amberAccent,
                onPressedAction: (){
                  setState(() {
                    _selectedBeerFilters = [];
                    _disoverBeersType = "most_voted";
                    _beers = WordpressAPI.getBeers(type: "most_voted");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Tendencia",
                isSelected: (_disoverBeersType == "trends" ? true : false ),
                icon: Icons.local_fire_department,
                color: Colors.red,
                onPressedAction: (){
                  setState(() {
                    _selectedBeerFilters = [];
                    _disoverBeersType = "trends";
                    _beers = WordpressAPI.getBeers(type: "trends");
                  });
                }
            ),
            _buildCategoryButton(
                text: "Verificadas",
                isSelected: (_disoverBeersType == "premium" ? true : false ),
                // icon: Icons.verified,
                icon: Icons.verified,
                //color: Color.fromRGBO(25, 119, 227, 1),
                color: BUTTON_GREEN,
                onPressedAction: (){
                  setState(() {
                    _selectedBeerFilters = [];
                    _disoverBeersType = "premium";
                    _beers = WordpressAPI.getBeers(type: "premium");
                  });
                }
            )
          ],
        )
    );
  }

  Widget _buildButtonText({ String text = "", isSelected = false }){
    return Text(text, style: TextStyle(
        fontSize: 15,
        color: BUTTONS_TEXT_DARK,
        fontWeight: (isSelected ? FontWeight.bold : FontWeight.normal )
    ));
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    backgroundColor.withOpacity(  (isSelected ? 1.0 : 0.4 )  )
                ),
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
        _buildButtonText(text: text, isSelected: isSelected)
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

        if (_selectedBeers.length > 0) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: MultiSelectChipDisplay(
            chipColor: Colors.black,
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            items: _selectedBeers.map((e) => MultiSelectItem(e, e.name)).toList(),
            //items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
            onTap: (value) {
              setState(() {

                _selectedBeers.remove(value);
              });
            },
          ),
        ),
        // more filters chips
        if (_selectedBeerFilters.length > 0) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: MultiSelectChipDisplay(
            icon: Icon(Icons.close),
            chipColor: Colors.black,
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            items: _selectedBeerFilters.map((e) => MultiSelectItem(e, e.name)).toList(),
            onTap: (value) {
              setState(() {
                _selectedBeerFilters = [];
                // back to default, could bet get back to last filter before this
                _disoverBeersType = "recent";
                _beers = WordpressAPI.getBeers(type: "recent");
                //_selectedBeerFilters.remove(value);
              });
            },
          ),
        ),

        FutureBuilder(
            future: _beers,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            //child: CircularProgressIndicator(color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0,)
                              child: Image.asset("assets/images/loader-hops.gif",width: 100,)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text("Cargando cervezas..."),
                          ),
                          SizedBox(height: 10),
                        ],
                      )
                  );
                default:
                  if (snapshot.hasError){
                    return Text('Ups! Error: ${snapshot.error}');
                  }else{
                    return Column(
                      children: [
                        _buildListGridView(),
                        SizedBox(height: 10,),
                        BeerCards(
                          loadingText: "Cargando cervezas...",
                          beersList: snapshot.data,
                          discoverBeersType: _disoverBeersType,
                          discoverBeersTypeExtraParam: _disoverBeersTypeExtraParam,
                        ),

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

