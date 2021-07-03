// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';

class EditUserInfo extends StatefulWidget {
  static const routeName = "edit-user-info";

  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  var _initialValues = {
    "name": '',
    "description": '',

  };
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (ctx,data,_)=> Scaffold(
        appBar: AppBar(title: Text('Edit Info ${data.nameUser}'),),
        body: ListView(
          children: [
            Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      right: 10, left: 5, bottom: 2, top: 4),
                  child: SizedBox(
                    height: 80,
                    width: 230,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'أدخل تفاصيل اكثر لإعلانك';
                        }
                        return null;
                      },
                      initialValue:
                      _initialValues['description'].toString(),
                      onSaved: (value) {

                      },

                      maxLines: 10,
                      //controller: descriptionController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'ضع تفاصيل أكثر لإعلانك ',
                        fillColor: Colors.grey,
                        hoverColor: Colors.grey,
                      ),
                      cursorRadius: Radius.circular(5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                    'ضع وصف للإعلان',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat-Arabic Regular',
                        height: 1.8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
            ),
          ],
        ),
      ),
    );
  }
}
