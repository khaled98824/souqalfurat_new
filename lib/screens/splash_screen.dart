import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Image.asset('assets/images/alsouq-poster.jpg',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height)
    );
  }
}
