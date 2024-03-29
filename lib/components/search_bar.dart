import 'package:flutter/material.dart';
import 'package:Hops/components/search_hops.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  /*
  final _textController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
  */
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom:1,
        left: MediaQuery.of(context).size.width * .05,
        right: MediaQuery.of(context).size.width * .05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(8, 6),
          ),
        ],

        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        maxLines: 1,
        // controller: _textController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          // errorText: _validate ? null : null,
          errorText: null,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.only(
            left: 0,
            bottom: 11,
            top: 11,
            right: 15,
          ),
          hintText: "Buscar cerveza o cervecería...",
        ),
        onSubmitted: (value) {
          showSearch(context: context, delegate: SearchHops(), query: value);
        },
      ),
    );
  }
}
