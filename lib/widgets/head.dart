import 'package:flutter/material.dart';


Widget head(screenSizeWidth2) {
  return Column(
    children: <Widget>[
      Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              screenSizeWidth2 < 380
                  ? SizedBox(
                width: 5,
              )
                  : SizedBox(
                width: 8,
              ),
              Text(
                'بيع واشتري كل ما تريد بكل سهولة',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'AmiriQuran',
                  height: 1,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      right: screenSizeWidth2 < 380 ? 11 : 28, left: 2),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 51,
                    width: 102,
                    fit: BoxFit.fill,
                  ))
            ],
          )),
    ],
  );
}