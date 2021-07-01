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
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sooq1alzour/ui/Report.dart';
//import 'package:sooq1alzour/ui/private_chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class ShowAd extends StatefulWidget {
  static const routeName = "/show-ad";

  String documentId;
  int indexDocument;
  ShowAd({this.documentId, this.indexDocument});
  @override
  _ShowAdState createState() => _ShowAdState(documentId: documentId);
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
int imageUrl4Show;
bool isRequest = true ;
var adImagesUrl = List<dynamic>();
bool showSlider = false;
bool showBody = false;

class _ShowAdState extends State<ShowAd> {
  String Messgetext;
  String documentId;
  int indexDocument;
  _ShowAdState({this.documentId});

  get loginStatus => null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
    Timer(Duration(microseconds: 200), () {
      print(documentId);
      setState(() {
        showMessages = true;
      });
    });
  }

  getDocumentValue() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    currentUserName = sharedPref.getString('name');
    DocumentReference documentRef =
    Firestore.instance.collection('Ads').document(documentId);
    documentsAds = await documentRef.get();
    var firestore = Firestore.instance;

    qusViews = await firestore
        .collection('Views')
        .where('Ad_id', isEqualTo: documentId)
        .getDocuments();

    DocumentReference documentRefUser =
    Firestore.instance.collection('users').document(currentUserName);
    documentsUser = await documentRef.get();
    adImagesUrl = documentsAds.data['imagesUrl'];
    setState(() {
      showSlider = true;
      showBody = true;
      isRequest = documentsAds.data['isRequest'];
    });

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
        'realTime':DateTime.now().millisecondsSinceEpoch.toString(),
      });
      documentRef = Firestore.instance.collection('Ads').document(documentId);
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
    return SafeArea(
      child: Scaffold(
        body: showBody
            ? Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsUser['name'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'AmiriQuran',
                          height: 0.7,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 30,
                          )),
                      SizedBox(width: 3,)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  showSlider
                      ? CarouselSlider(
                    items: adImagesUrl.map((url) {
                      return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     BouncyPageRoute(
                                //         widget: PageImage(
                                //             imageUrl: adImagesUrl[
                                //             imageUrl4Show])));
                              },
                              child: Container(
                                child: Hero(
                                    tag: Text('imageAd'),
                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(17),
                                        child: Image.network(url))),
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
                      : Container(),
                  SizedBox(
                    height: 5,
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
                                  scrollController
                                      .position.maxScrollExtent,
                                  duration:
                                  const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'علق',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: 'AmiriQuran',
                                    height: 0.7,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
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
                          width: 130,
                          height: 34,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blueAccent),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'دردشة خاصة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'AmiriQuran',
                                  height: 0.7,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8,
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
                          launch('tel:${documentsAds['phone']}');
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
                              Text(
                                'اتصل',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: 'AmiriQuran',
                                  height: 0.7,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 12,
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
                      EdgeInsets.only(top: 20, bottom: 10, right: 10),
                      child: Text(
                        documentsAds['name'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'AmiriQuran',
                          height: 0.7,
                          color: Colors.black,
                        ),
                      )),
                  Padding(
                      padding:
                      EdgeInsets.only(top: 4, bottom: 5, right: 10),
                      child: Text(
                        documentsAds['time'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'AmiriQuran',
                          height: 0.7,
                          color: Colors.black,
                        ),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['uid'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        ': المعلن ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height:7,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height:7,
                  ),
                  isRequest ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'طلب',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.red[600],
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        ': طلب ام إعلان ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ):Container(),
                  isRequest ?SizedBox(
                    height:7,
                  ):Container(),
                  isRequest ? Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ):Container(),

                  isRequest ? SizedBox(
                    height:5,
                  ):Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['area'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': المنطقة ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['description'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'AmiriQuran',
                          height: 1.3,
                          wordSpacing: 0,
                          letterSpacing: 0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        ': الوصف ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['status'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': الحالة ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['category'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': القسم ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['department'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        ': القسم الفرعي ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['phone'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': موبايل ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        qusViews.documents.length.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': المشاهدات ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        documentsAds['price'].toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        ': السعر ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: InkWell(
                      onTap: (){
                       // Navigator.push(context, BouncyPageRoute(widget: Report(adId: documentId,)));
                      },
                      child: Container(
                          child:Column(
                            children: [
                              Icon(
                                Icons.report_problem_outlined,
                                color: Colors.red,
                                size: 32,),
                              Text('الإبلاغ عن محتوى مخالف', textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'AmiriQuran',
                                  height: 1,
                                  color: Colors.grey[700],
                                ),),
                            ],
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 6,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey),
                  ),
                  showMessages
                      ? Padding(
                    padding: EdgeInsets.only(
                        top: 10, right: 10, left: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("messages")
                          .where('Ad_id', isEqualTo: documentId)
                          .orderBy('realTime',descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: Column(
                                children: <Widget>[
                                  // CircularProgressIndicator(strokeWidth: 1,),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '!...لا توجد تعليقات ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'AmiriQuran',
                                      height: 1,
                                      color: Colors.grey[500],
                                    ),
                                  )
                                ],
                              ));
                        }
                        docs = snapshot.data.documents;
                        List<Widget> messages = docs
                            .map((doc) => Message(
                            from: doc.data["from"],
                            text: doc.data["text"],
                            time: doc.data['date'],
                            me: documentsUser['name'] ==
                                doc.data["name"]))
                            .toList();

                        return Column(
                          children: <Widget>[
                            ...messages,
                          ],
                        );
                      },
                    ),
                  )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: loginStatus
                        ? Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 10, left: 10,top: 0),
                              child: TextField(
                                controller: messageController,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "!... اكتب تعليقك هنا",
                                ),
                                onSubmitted: (value) => callBack(),
                              ),
                            ),
                          ),
                          loginStatus
                              ? SendButton(
                            text: 'ارسل',
                            callback: callBack,
                          )
                              : Container(),
                        ],
                      ),
                    )
                        : Container(),
                  )
                ],
              ),
            ),
          ],
        )
            : Center(
          child: SpinKitFadingCircle(
            color: Colors.red,
            size: 100,
            duration: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showBody=false;
    //docs.clear();
  }
}

class PageImage extends StatefulWidget {
  String imageUrl;
  PageImage({Key key, @required this.imageUrl}) : super(key: key);
  @override
  _PageImageState createState() => _PageImageState(imageUrl: imageUrl);
}

class _PageImageState extends State<PageImage> {
  String imageUrl;
  _PageImageState({Key key, @required this.imageUrl});
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
                itemCount: adImagesUrl.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(adImagesUrl[index]),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2);
                },
                enableRotation: true,
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
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
                Text('عدد الصور  ${adImagesUrl.length}',textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18
                  ),),
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

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String time;

  final bool me;

  const Message({Key key, this.from, this.text, this.me, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: me ? Alignment(1, 0) : Alignment(-1, 0),
      child: Padding(
        padding: EdgeInsets.only(top: 12),
        child: Container(
          child: Column(
            crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                from,
                style: TextStyle(fontSize: 12, color: Colors.blue[800]),
              ),
              SizedBox(
                height: 2,
              ),
              Material(
                color: me ? Colors.teal[100] : Colors.white70,
                borderRadius: BorderRadius.circular(5),
                elevation: 5,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: me
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          time,
                          style:
                          TextStyle(fontSize: 11, color: Colors.deepOrange),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
