// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import 'package:souqalfurat/providers/full_provider.dart';
import 'package:souqalfurat/screens/add_new_ad.dart';
import 'package:souqalfurat/screens/my_Ads.dart';
import 'package:souqalfurat/screens/my_chats.dart';
import 'package:souqalfurat/screens/profile_screen.dart';
import 'package:souqalfurat/widgets/head.dart';
import 'package:souqalfurat/widgets/new_Ads.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:souqalfurat/widgets/option_home.dart';
import 'package:souqalfurat/widgets/searchArea.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'auth_screen.dart';
import 'constants.dart';

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

  var adImagesUrlF = [];
  bool adsOrCategory = false;
  getUrlsForAds() async {
    DocumentSnapshot documentsAds;
    bool showSliderAds = false;

    DocumentReference documentRef = Firestore.instance
        .collection('UrlsForAds')
        .document('gocqpQlhow2tfetqlGpP');
    documentsAds = await documentRef.get();
    adImagesUrlF = documentsAds.data['urls'];
    return adImagesUrlF;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentIndex = 4;
    });
    Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final fullDataP = Provider.of<FullDataProvider>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            head(screenSizeWidth),
            SizedBox(
              height: 4,
            ),
            SearchAreaDesign(),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 32,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[300]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      //Navigator.push(context, BouncyPageRoute(widget: Exchange()));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text('سعر الصرف',
                              style: Theme.of(context).textTheme.headline5),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[400]),
                    height: 30,
                    width: 1,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        adsOrCategory = true;
                      });
                    },
                    child: Container(
                        child: Row(
                      children: [
                        Text('الإعلانات',
                            style: Theme.of(context).textTheme.headline5)
                      ],
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[400]),
                    height: 30,
                    width: 1,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        adsOrCategory = false;
                      });
                    },
                    child: Container(
                        child: Row(
                      children: [
                        Text('الأقسام',
                            style: Theme.of(context).textTheme.headline5)
                      ],
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Consumer<FullDataProvider>(
                builder: (context, data, _) => FutureBuilder(
                    future: fullDataP.getUrlsForAds(),
                    builder: (context, data) =>
                        data.connectionState == ConnectionState.waiting
                            ? CircularProgressIndicator()
                            : Container(
                                width: screenSizeWidth - 10,
                                height: 85,
                                child: new Swiper(
                                  itemBuilder: (ctx, int index) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Hero(
                                          tag: Text('imageAd'),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child: Image.network(
                                                data.data[index],
                                                fit: BoxFit.fill,
                                                // height: 75,
                                                // width: 390,
                                              ))),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemCount: fullDataP.adImagesUrlF.length,
                                  itemWidth: screenSizeWidth - 10,
                                  itemHeight: 99.0,
                                  duration: 2000,
                                  autoplayDelay: 13000,
                                  autoplay: true,
                                  // pagination: new SwiperPagination(
                                  //   alignment: Alignment.centerRight,
                                  // ),
                                  control: new SwiperControl(
                                    size: 18,
                                  ),
                                ),
                              ))),
            SizedBox(
              height: 10,
            ),
            adsOrCategory
                ? NewAdsItems()
                : Column(
                    children: [
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "أجهزة - إلكترونيات",
                              imagePath: _listItem[0],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "السيارات - الدراجات",
                              imagePath: _listItem[1],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "الموبايل",
                              imagePath: _listItem[2],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "وظائف وأعمال",
                              imagePath: _listItem[3],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "مهن وخدمات",
                              imagePath: _listItem[4],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "المنزل",
                              imagePath: _listItem[5],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "المعدات والشاحنات",
                              imagePath: _listItem[6],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "المواشي",
                              imagePath: _listItem[7],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "الزراعة",
                              imagePath: _listItem[8],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "ألعاب",
                              imagePath: _listItem[9],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "ألبسة",
                              imagePath: _listItem[10],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                            ItemCategory(
                              text: "أطعمة",
                              imagePath: _listItem[11],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            )
                          ]),
                      Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceAround,
                          children: <Widget>[
                            ItemCategory(
                              text: "طلبات المستخدمين",
                              imagePath: _listItem[12],
                              callback: () {},
                              screenSizeWidth2: screenSizeWidth,
                            ),
                          ]),
                    ],
                  )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey[400], fontFamily: 'Montserrat-Arabic Regular'),
        selectedLabelStyle: TextStyle(
            color: Colors.black, fontFamily: 'Montserrat-Arabic Regular'),
        fixedColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userTie),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.images), label: 'إعلاناتي'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: 35,
                color: Colors.orange,
              ),
              label: 'أضف إعلان'),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.comments),
            label: 'محادثاتي',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 4) {
      Navigator.pushNamed(context, HomeScreen.routeName);
      print(index);
    } else if (_currentIndex == 3) {
      print(index);

      Navigator.pushNamed(context, MyChats.routeName);
    } else if (_currentIndex == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => AddNewAd(context, null)));
      print(index);
    } else if (_currentIndex == 1) {
      Navigator.pushNamed(context, MyAds.routeName);
      print(index);
    } else if (_currentIndex == 0) {
      print(index);

      Navigator.pushNamed(context, Profile.routeName);
    }
  }

  int _currentIndex = 4;
}

class ItemCategory extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final String imagePath;
  final double screenSizeWidth2;

  ItemCategory({
    this.text,
    this.callback,
    this.imagePath,
    this.screenSizeWidth2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        elevation: 0,
        child: SizedBox(
          width: screenSizeWidth2 > 395 ? 190 : 172,
          height: 170,
          child: Container(
            width: 100,
            //width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.fill),
              color: Colors.redAccent,
            ),
            child: Transform.translate(
                offset: Offset(11, -68),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13, vertical: 71),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[100]),
                    child: Center(
                      child: Text(text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3),
                    ))),
          ),
        ),
      ),
    );
  }
}
