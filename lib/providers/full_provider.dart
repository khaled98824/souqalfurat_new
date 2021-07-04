import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FullDataProvider with ChangeNotifier {
  var adImagesUrlF = [];
  var adImagesUrlF2 = [2,2];


  Future getUrlsForAds() async {
    DocumentSnapshot documentsAds;
     DocumentReference documentRef = Firestore.instance
        .collection('UrlsForAds')
        .document('gocqpQlhow2tfetqlGpP');
    documentsAds = await documentRef.get();
    adImagesUrlF = documentsAds.data['urls'];
  return adImagesUrlF;
  }
  notifyListeners() ;

}