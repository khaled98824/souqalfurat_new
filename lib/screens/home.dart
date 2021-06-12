import 'package:flutter/material.dart';
import 'package:souqalfurat/widgets/head.dart';
import 'package:souqalfurat/widgets/option_home.dart';
import 'package:souqalfurat/widgets/searchArea.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _listItem = [
    'assets/images/Elct2.jpg',
    'assets/images/cars.jpg',
    'assets/images/mobile3.jpg',
    'assets/images/jobs3.jpg',
    'assets/images/SERV3.jpg',
    'assets/images/home3.jpg',
    'assets/images/trucks3.jpg',
    'assets/images/farm7.jpg',
    'assets/images/farming3.jpg',
    'assets/images/game.jpg',
    'assets/images/clothes.jpg',
    'assets/images/food.jpg',
    'assets/images/requests.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    final screenSizeWidth =MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          head(screenSizeWidth),
          SizedBox(height: 12,),
          SearchAreaDesign(),
          SizedBox(height: 12,),
optionsHome(context)
        ],
      ),),
    );
  }
}
