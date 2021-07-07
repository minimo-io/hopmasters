import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';

import 'package:Hops/services/wordpress_api.dart';
import 'package:Hops/components/beer_cards.dart';

class DiscoverBeers extends StatefulWidget {
  const DiscoverBeers({Key? key}) : super(key: key);

  @override
  _DiscoverBeersState createState() => _DiscoverBeersState();
}

class _DiscoverBeersState extends State<DiscoverBeers> {
  Future? _breweryBeers;


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
                            child: Column(
                              children: [


                              ],
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
            _buildCategoryButton(text: "Recientes", icon: Icons.schedule, color: Colors.white, isSelected: true),
            _buildCategoryButton(text: "Tendencia", icon: Icons.local_fire_department, color: Colors.red),
            _buildCategoryButton(text: "Mas votadas", icon: Icons.star, color: Colors.amberAccent),
            _buildCategoryButton(text: "Premium", icon: Icons.verified, color: Color.fromRGBO(25, 119, 227, 1))
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
    bool isSelected = false
  }){
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ElevatedButton(

            onPressed: (){
              print("Category pressed");
            },
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
          OutlinedButton(
            onPressed: () {
              print('Received click');
            },
            child: Row(
              children: [
                Icon(Icons.grid_view_sharp, color: Colors.black,),
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
                Icon(Icons.view_list_outlined, color: BUTTONS_TEXT_DARK,),
                Text("Lista", style: TextStyle( color: BUTTONS_TEXT_DARK ),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _breweryBeers = WordpressAPI.getBeersFromBreweryID("89107");
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),

        _discoverBeersHeader(),
        SizedBox(height: 15,),

        _disconverBeersCategories(),

        SizedBox(height: 30,),


        FutureBuilder(
            future: _breweryBeers,
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
                        BeerCards( beersList: snapshot.data, ),
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
