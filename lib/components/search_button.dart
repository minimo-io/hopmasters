import 'package:Hops/components/search_hops.dart';
import 'package:Hops/constants.dart';
import 'package:flutter/material.dart';
import 'package:Hops/theme/style.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  _hmSearchButtonState createState() => _hmSearchButtonState();
}

class _hmSearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //backgroundColor: SECONDARY_BUTTON_COLOR,
      backgroundColor: mainButtonsColor,
      foregroundColor: Colors.white,
      onPressed: () => showSearch(
        context: context,
        delegate: SearchHops(),
      ),
      child: const Icon(Icons.search),
    );
  }
}
