// @dart=2.9

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String name;
  final String creatorName;
  final String id;
  String creatorId;
  final String category;
  final String department;
  final String time;
  final String status;
  final String description;
  final String area;
  final double price;
  final String deviceNo;
  final List imagesUrl;
  final int phone;
  final String uid;
  int likes;
  final int views;
  final bool isRequest;
  final bool isFavorite;

  Product({
    @required this.id,
    @required this.creatorName,
    @required this.creatorId,
    @required this.name,
    @required this.category,
    @required this.department,
    @required this.time,
    @required this.status,
    @required this.description,
    @required this.area,
    @required this.price,
    @required this.deviceNo,
    @required this.imagesUrl,
    @required this.phone,
    @required this.uid,
    @required this.likes,
    @required this.views,
    @required this.isRequest,
    this.isFavorite,
  });

  void _setFavValue(bool newValue) {
    //isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    // isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://shop-1d972-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorite/$userId/.json?auth=$token';

    try {
      final res = await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}
