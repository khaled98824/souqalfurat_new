// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import 'package:souqalfurat/screens/edit_account.dart';

import 'auth_screen.dart';
import 'my_Ads.dart';
import 'my_chats.dart';
import 'user_ads_screen.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid;

  String userName;
  bool done = false;
  DocumentSnapshot documentsUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    uid = Provider.of<Auth>(context).userId;
    final userGetData = Provider.of<Auth>(context, listen: false);
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed('/');
                              Provider.of<Auth>(context, listen: false).loguot();
                            },
                            child: Icon(
                              Icons.exit_to_app,
                              size: 24,
                              color: Colors.deepOrange,
                            )),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          'تسجيل خروج',
                          textAlign: TextAlign.center,
                          style:Theme.of(context).textTheme.headline3
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment(0.9, 0),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 1),
                  child: Container(
                    child: Consumer<Auth>(
                      builder: (cxt, value, _) => Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 27,
                                      child: Icon(
                                        Icons.perm_identity,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Consumer<Auth>(builder: (ctx, value, _) {
                                      return Text(
                                        '${value.nameUser}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.headline3,
                                      );
                                    }),
                                    SizedBox(
                                      width: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("${value.dateUser} : عضو منذ ",
                                  style: Theme.of(context).textTheme.headline3),
                              SizedBox(
                                width: 3,
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('${value.areaUser} : المنطقة',
                                  style:Theme.of(context).textTheme.headline3),
                              SizedBox(
                                width: 4,
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 3,
                            color: Colors.red,
                          ),
                         Padding(
                           padding: EdgeInsets.symmetric(horizontal: 4),
                           child: Column(

                             children: [
                               Container(
                                 width: MediaQuery.of(context).size.width,
                                 height: 1,
                                 color: Colors.grey,
                               ),
                               info(Icons.chat_outlined, 'دردشاتي', (){}, Colors.blueAccent),
                               info(Icons.auto_awesome_motion, 'إعلاناتي', (){}, Colors.blueAccent),
                               info(Icons.shopping_cart_outlined, 'طلباتي', (){}, Colors.blue[900]),
                               info(Icons.markunread_mailbox, 'الشكاوى والإقتراحات', (){},Colors.yellow),
                               info(Icons.security, 'سياسة الخصوصية وشروط الاستخدام', (){},Colors.red),
                               info(Icons.verified_user, 'آدمن', (){},Colors.yellow),
                               info(Icons.info, 'حول التطبيق', (){},Colors.blueAccent),
                               info(Icons.call, 'اتصل بنا', (){},Colors.blueAccent),

                             ],
                           ),
                         ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              //edit account
                              Navigator.pushNamed(context, EditUserInfo.routeName);
                            },
                            child: Container(
                                width: 230,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[400]),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('تعديل معلومات حسابي',
                                          textAlign: TextAlign.right,
                                          style:Theme.of(context).textTheme.headline3),
                                      IconButton(
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            size: 25,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: () {}),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );

  }
  Widget info(icon,title,callback,colorIcon){
    return Column(
      children: [
        InkWell(
          onTap: callback,
          child: Padding(
            padding:
            EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 5,),
                Icon(FontAwesomeIcons.caretLeft),
                Spacer(),
                Text(title,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[400]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 4, horizontal: 12),
                    child: Center(
                      child: Icon(
                        icon,
                        color: colorIcon,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4,)
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width-30,
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
