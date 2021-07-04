import 'package:flutter/material.dart';

class MyAds extends StatefulWidget {
  static const routeName = "/my_ads";

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Ads'),),
    );
  }
}
