// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:souqalfurat/screens/auth_screen.dart';
import '../models/http_exception.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String uid2 ;
  String nameUser;
  String areaUser;
  String dateUser;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      [String email, String password, String urlSegment , String name , String area ,bool signUp]) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCElvO52-8gNnyAl_kOiN3sBGhaGDhdLGE';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      uid2=_userId;

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLoguot();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final prefs2 = await SharedPreferences.getInstance();
      String userData2 = json.encode({
        'email':email,
        'password':password,
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs2.setString('info',userData2);

      String userData = json.encode({
        'email':email,
        'password':password,
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      //save user info in firebase users

        if(signUp)Firestore.instance.collection('users').document(_userId)
            .setData({
          'token':_token,
          'name': name,
          'user_uid': _userId,
          'area': area,
          'email':email,
          'password': password,
          "time": DateFormat('yyyy-MM-dd-HH:mm')
              .format(DateTime.now()),
        });

    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password, String name, String area) async {
    print('SignUp');
    return _authenticate(email, password, 'signUp',name,area,true);
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword','','',false);
  }

  Future gitCurrentUserInfo()async{
    DocumentSnapshot documentsUser;
    DocumentReference documentRef =
      Firestore.instance.collection('users').document(_userId);
      documentsUser = await documentRef.get();
      nameUser = documentsUser['name'];
      areaUser = documentsUser['area'];
      dateUser = documentsUser['time'];
    notifyListeners();
    return documentsUser;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLoguot();
    return true;
  }

  Future<void> loguot() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLoguot() async {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), loguot);
  }
}
