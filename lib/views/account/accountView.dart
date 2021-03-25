import 'package:flutter/material.dart';
import 'package:hopmasters/components/top_app_bar.dart';
import 'components/body.dart';

class AccountView extends StatefulWidget {
  final String userID;

  const AccountView ({ Key key, this.userID }): super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  // widget.breweryID
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body: Body(),
    );
  }
}