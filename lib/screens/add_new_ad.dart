import 'package:flutter/material.dart';

class AddNewAd extends StatefulWidget {
  static const routeName = "/add_new_ad";

  @override
  _AddNewAdState createState() => _AddNewAdState();
}

class _AddNewAdState extends State<AddNewAd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Ad'),),
    );
  }
}
