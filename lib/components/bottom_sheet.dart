import 'package:flutter/material.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.



/*
class _PersistentBottomSheetDemo extends StatefulWidget {
  @override
  _PersistentBottomSheetDemoState createState() =>
      _PersistentBottomSheetDemoState();
}

class _PersistentBottomSheetDemoState
    extends State<_PersistentBottomSheetDemo> {
  VoidCallback _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showPersistentBottomSheet;
  }
*/
  void showPersistentBottomSheet(BuildContext context) {
    /*
    setState(() {
      // Disable the show bottom sheet button.
      _showBottomSheetCallback = null;
    });
  */
    Scaffold.of(context)
        .showBottomSheet<void>(
          (context) {
        return Container(
          height: 430,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 70,
                child: Center(
                  child: Text(
                    "COMPRAR",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: 21,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Comprar"),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      elevation: 25,
    )
        .closed
        .whenComplete(() {
          /*
          if (mounted) {
            setState(() {
              // Re-enable the bottom sheet button.
              _showBottomSheetCallback = _showPersistentBottomSheet;
            });
          }
          */
    });
  }
  /*
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _showBottomSheetCallback,
        child: Text("Show bottom "),
      ),
    );
  }
}
   */

