// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souqalfurat/providers/ads_provider.dart';

//import 'package:sooq1alzour/ui/Report.dart';
//import 'package:sooq1alzour/ui/private_chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class ShowAd extends StatefulWidget {
  static const routeName = "/show-ad";

  String adId;
  int indexAd;

  ShowAd({this.adId, this.indexAd});

  @override
  _ShowAdState createState() => _ShowAdState(adId: adId);
}

List<DocumentSnapshot> docs;
QuerySnapshot qusViews;
DocumentSnapshot documentsAds;
DocumentSnapshot documentsUser;
DocumentSnapshot documentMessages;
List<Widget> messages;
bool showMessages = false;
String currentUserName;
TextEditingController messageController = TextEditingController();
ScrollController scrollController = ScrollController();
int imageUrl4Show = 0;
bool isRequest = true;

var adImagesUrl = List<dynamic>();
bool showSlider = false;
bool showBody = false;
var ads;

class _ShowAdState extends State<ShowAd> {
  String Messgetext;
  String adId;
  int indexDocument;

  _ShowAdState({this.adId});

  get loginStatus => null;
  bool showSlider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  makePostRequest(token1, AdsN) async {
    DocumentReference documentRefUser =
    Firestore.instance.collection('users').document('currentUserId');
    documentsUser = await documentRefUser.get();
    print("enter");
    final key1 =
        'AAAAEqhhPwA:APA91bFNtgChlqlvVRjG0sYMUQUUKJpQlreNC1a0IAV_4ZZTIhdqYGq72IgGdRxnt4vt-9-yoowVbYwHzS6azKwV4GGCEm3WzVdQqS2t2JjyQcPZ5ZR_EQTmyJ69abl4cSE5nFymWR2F';
    final uri = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "key=" + key1
    };
    Map<String, dynamic> title = {
      'title': "${documentsUser.data['name']} علق على  ${AdsN}",
      "Mess": "${Messgetext}"
    };
    Map<String, dynamic> body = {'data': title, "to": token1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(statusCode);
    print(responseBody);
  }

  final Firestore _firestore = Firestore.instance;

  Future<void> callBack() async {
    DocumentReference documentRef;

    if (messageController.text.length > 0) {
      Messgetext = messageController.text;
      await _firestore.collection("messages").add({
        'text': Messgetext,
        //'from': currentUserId,
        'date': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'name': documentsUser['name'],
        'Ad_id': documentsAds.documentID,
        'realTime': DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
      });
      documentRef = Firestore.instance.collection('Ads').document(adId);
      documentsAds = await documentRef.get();
      documentRef = Firestore.instance
          .collection('users')
          .document(documentsAds.data['uid']);
      documentsUser = await documentRef.get();
      print("token" + documentsUser.data['token']);
      print(documentsAds.data['uid']);
      print(documentsUser.documentID);
      if (documentsAds.data['uid'] != 'currentUserId') {
        makePostRequest(documentsUser.data['token'], documentsAds.data['name']);
      }

      setState(() {});
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    var ads = Provider.of<Products>(context).findById(adId);

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        showSlider = false;
      });
    });
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(ads.name, style: Theme
                .of(context)
                .textTheme
                .headline4),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<Products>(
                        builder: (ctx, data, _) =>
                            CarouselSlider(
                              items: ads.imagesUrl.map((url) {
                                return Builder(
                                    builder: (BuildContext context) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PageImage(ads
                                                          .imagesUrl[imageUrl4Show],
                                                         )));
                                        },
                                        child: Container(
                                          child: Hero(
                                              tag: Text('imageAd'),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(17),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Image.network(
                                                    url, fit: BoxFit.cover,),
                                                ),)),
                                        ),
                                      );
                                    });
                              }).toList(),
                              options: CarouselOptions(
                                initialPage: 0,
                                autoPlay: true,
                                onPageChanged: (a, b) {
                                  imageUrl4Show = a;
                                },
                                pauseAutoPlayOnTouch: true,
                                autoPlayAnimationDuration:
                                Duration(milliseconds: 900),
                                disableCenter: false,
                                height: 250,),
                            )

                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: InkWell(
                              onTap: () {
                                messageController.clear();
                                scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('علق',
                                      textAlign: TextAlign.center,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline4),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.comment,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //Navigator.push(context, BouncyPageRoute(widget: PrivateChat(documentId: documentId,recipient:documentsAds['uid'] ,)));
                          },
                          child: Container(
                            width: 150,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('دردشة خاصة',
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline4),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.mark_chat_read_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launch('tel:${ads.phone}');
                          },
                          child: Container(
                            width: 90,
                            height: 34,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blueAccent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('اتصل',
                                    textAlign: TextAlign.center,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline4),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding:
                        EdgeInsets.only(top: 12, bottom: 4, right: 10),
                        child: Text(ads.creatorName,
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline5)),
                    Padding(
                        padding:
                        EdgeInsets.only(top: 0, bottom: 4, right: 10),
                        child: Text(ads.area,
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3)),
                    Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 5, right: 10),
                        child: Text(ads.time,
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline3)),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 6,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 6,
                      height: 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    info(ads.category,(){},'القسم الرئيسي'),
                    info(ads.department,(){},'القسم الفرعي'),
                    info(ads.description,(){},'  الحالة'),
                    info(ads.status,(){},'الوصف'),
                    info(ads.id,(){},'    Id'),

                    Center(
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(context, BouncyPageRoute(widget: Report(adId: documentId,)));
                        },
                        child: Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  color: Colors.red,
                                  size: 32,
                                ),
                                Text(
                                  'الإبلاغ عن محتوى مخالف',
                                  textAlign: TextAlign.center,
                                  style:Theme.of(context).textTheme.headline3
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 88,
                    ),

                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showBody = false;
    //docs.clear();
  }
  Widget info(value,callback,title){
    return Column(
      children: [
        InkWell(
          onTap:callBack,
          child: Container(
            color: Colors.grey.shade300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4,top: 4),
                  child: Text(value,style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.center,),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4,top: 4),
                  child: Text(title,style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.end,),
                ),
                SizedBox(width:8,)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 6,
          height: 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[300]),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class PageImage extends StatefulWidget {
  String imageUrl;
  PageImage(this.imageUrl);

  @override
  _PageImageState createState() => _PageImageState(imageUrl);
}

class _PageImageState extends State<PageImage> {
  String imageUrl;

  _PageImageState(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'الصورة',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'AmiriQuran',
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: PhotoViewGallery.builder(
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrl),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2);
                },
                enableRotation: true,
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .canvasColor,
                ),
                //loadingChild: CircularProgressIndicator(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                      color: Colors.blue,
                    )),
                Text(
                  'عدد الصور  ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 28,
                      color: Colors.blue,
                    )),
              ],
            ),
          ],
        ));
  }
}
