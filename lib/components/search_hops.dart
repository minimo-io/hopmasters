import 'package:flutter/material.dart';
import 'package:Hops/constants.dart';
import 'package:Hops/theme/style.dart';
import 'package:Hops/services/wordpress_api.dart';


class SearchHops extends SearchDelegate{
  SearchHops() : super(searchFieldLabel: "Buscar...");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = "";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: ()=> close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty){
      return Container(
          decoration: BoxDecoration(
            gradient: PRIMARY_GRADIENT_COLOR,
          ),
          child: Center(child: Text("¡Encuentra cervezas y cervecerías!"))
      );
    }else{
      return FutureBuilder(
        future: WordpressAPI.search(query: query),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData){
            return Container(
              decoration: BoxDecoration(
                gradient: PRIMARY_GRADIENT_COLOR,
              ),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  Map result = snapshot.data[index];
                  return ListTile(
                    title: Text(result["name"]),
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        "/beer",
                        arguments: { 'beerId': result["id"] },

                      );
                    },
                  );
                }
              ),
            );
          }else{
            return Container(
                decoration: BoxDecoration(
                  gradient: PRIMARY_GRADIENT_COLOR,
                ),
                child: Center(child: CircularProgressIndicator( color: PROGRESS_INDICATOR_COLOR, strokeWidth: 1.0, ),)
            );
          }
        }
      );
    }
  }


}