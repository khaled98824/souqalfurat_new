// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souqalfurat/models/ads_model.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import '../screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';

class AddNewAd extends StatefulWidget {
  static const routeName = "AddNewAd";
  final BuildContext ctx;

  final String id;

  AddNewAd(this.ctx, this.id);

  @override
  _AddNewAdState createState() => _AddNewAdState(ctx, id);
}

bool loadingImage = false;
var time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
String priceText;
double price = 0;
File imageG;
File image;
File image2;
File image3;
File image4;
File image5;
File image6;
File image7;
String imageUrl;
String imageUrl2;
String imageUrl3;
String imageUrl4;
String imageUrl5;
String imageUrl6;
String imageUrl7;
int phone;

var _editedProduct = Product(
  id: '',
  name: '',
  description: '',
  price: 0.0,
  imagesUrl: ['', ''],
  area: '',
  category: '',
  department: '',
  status: '',
  isFavorite: false,
  uid: '',
  likes: 0,
  views: 0,
  phone: 0,
  isRequest: false,
);
var _initialValues = {
  "name": '',
  "description": '',
  "price": 0.0,
  "imagesUrl": '',
  "area": '',
  "category": '',
  "department": '',
  "status": '',
  "isFavorite": '',
  "uid": '',
  "likes": '',
  "views": '',
  "phone": 0,
  "isRequest": '',
};
var _isInit = true;
var _isLoading = false;

class _AddNewAdState extends State<AddNewAd> {
  final BuildContext ctx;

  final String id;

  _AddNewAdState(this.ctx, this.id);

  @override
  didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('idd $id');

    print('name prod ${_editedProduct.name}');
    if (_isInit) {
      if (id != null) {
        _editedProduct = Provider.of<Products>(ctx).findById(id);

        print(' prodId = $productId');
        _initialValues = {
          'id': _editedProduct.id,
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price,
          'area': _editedProduct.area,
          'phone': _editedProduct.phone,
          'status': _editedProduct.status,
          'deviceNo': _editedProduct.deviceNo,
          'category': _editedProduct.category,
          'uid': _editedProduct.uid,
          'department': _editedProduct.department,
          'imagesUrl': _editedProduct.imagesUrl,
          'isFavorite': _editedProduct.isFavorite,
          'isRequest': _editedProduct.isRequest,
          'views': _editedProduct.views,
          'likes': _editedProduct.likes,
        };
        urlImages = _editedProduct.imagesUrl;
        category = _editedProduct.category;
        category2 = _editedProduct.department;
        status = _editedProduct.status;
        area = _editedProduct.area;
      }
      _isInit = false;
    }
  }

  bool choseCategory = true;
  bool choseCategory2 = true;
  bool statusShow = true;
  bool showAreaTextField = false;
  var dropItemsGames = [
    'إختر القسم الفرعي',
    'ألعاب موبايل',
    'ألعاب كمبيوتر',
    "ألعاب وتسالي الأطفال",
    "أخرى"
  ];
  var dropItemsOccupationsAndServices = [
    'إختر القسم الفرعي',
    'البناء',
    'صيانة المنزل',
    "خدمات التنظيف",
    "خدمات مناسبات",
    "خدمات توصيل",
    "أخرى"
  ];
  var dropItemsFood = [
    'إختر القسم الفرعي',
    'أجبان ألبان - مونة',
    'حلويات',
    "أطعمة شعبية",
    "أخرى"
  ];
  var dropItemsLivestocks = [
    'إختر القسم الفرعي',
    'أغنام',
    'أبقار',
    "طيور",
    "أعلاف"
  ];
  var dropItemsFarming = [
    'إختر القسم الفرعي',
    'معدات زراعية',
    'مواد زراعية وبذور',
    "ورش الأعمال الزراعية",
    "مشاتل - أغراس"
  ];
  var dropItemsClothes = [
    'إختر القسم الفرعي',
    'ألبسة رجالية',
    'ألبسة نسائية',
    "ألبسة ولادي-بناتي",
    "ألبسة أطفال",
    "أقمشة"
  ];
  var dropItemsHome = [
    'إختر القسم الفرعي',
    'أجهزة كهربائية',
    'أثاث',
    "منسوجات - سجاد",
    "أدوات المطبخ",
    "أبواب - شبابيك - ألمنيوم",
    "أخرى"
  ];
  var dropItemsDevicesAndElectronics = [
    'إختر القسم الفرعي',
    'لابتوب - كمبيوتر',
    'تلفزيون شاشات',
    "كاميرات - تصوير",
    "طابعات",
    "راوترات - أجهزة إنترنت",
    "أخرى"
  ];
  var dropItemsCars = [
    'إختر القسم الفرعي',
    'سيارات للبيع',
    'سيارات للإيجار',
    "قطع غيار",
    "دراجات نارية للبيع"
  ];
  var dropItemsMobile = [
    'إختر القسم الفرعي',
    'أبل',
    'هواوي',
    'سامسونج',
    'صيانة الموبايل',
    'إكسسوارات'
  ];
  var dropItemsCategory2 = [
    'إختر القسم الفرعي',
  ];
  var dropSelectItemCategory2 = 'إختر القسم الفرعي';
  String category2 = '';

  var dropItemsCategory = [
    'إختر القسم الرئيسي',
    'السيارات - الدراجات',
    'الموبايل',
    'أجهزة - إلكترونيات',
    'وظائف وأعمال',
    'مهن وخدمات',
    'المنزل',
    'المعدات والشاحنات',
    'المواشي',
    'الزراعة',
    'ألعاب',
    'ألبسة',
    'أطعمة'
  ];
  var dropSelectItemCategory = 'إختر القسم الرئيسي';
  String category = '';
  List<String> dropItemsArea = [
    'إختر المحافظة',
  ];

  var dropSelectItemArea = 'إختر المحافظة';
  String area = '';
  bool chacked = false;
  bool chacked2 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  var status = 'مستعمل';
  var urlImages = List<String>();
  String imageUrl;

  upImage() async {
    loadingImage = true;

    var storageImage = FirebaseStorage.instance.ref().child(_image.path);
    var taskUpload = storageImage.putFile(_image);
    imageUrl = await (await taskUpload.onComplete).ref.getDownloadURL();
    print(imageUrl);
    loadingImage = false;
    setState(() {
      urlImages.add(imageUrl);
      loadingImage = false;

      print(urlImages);

      //show
      if (image == null) {
        image = _image;
      } else if (image2 == null) {
        image2 = _image;
      } else if (image3 == null) {
        image3 = _image;
      } else if (image4 == null) {
        image4 = _image;
      } else if (image5 == null) {
        image5 = _image;
      } else if (image6 == null) {
        image6 = _image;
      } else if (image7 == null) {
        image7 = _image;
      }
    });
  }

  File _image;

  Future getImage(context) async {
    imageG = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageG;
    });
    upImage();
  }

  getInfoDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var infoData = androidInfo.androidId;
    setState(() {
      deviceNo = infoData;
      print(deviceNo);
    });
  }

  getIosInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      deviceNo = iosInfo.identifierForVendor;
      print(deviceNo);
    });
  }

  String deviceNo = '';

  int currentIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      getInfoDevice();
    } else {
      getIosInfo();
    }
    addNewZ();
  }

  QuerySnapshot documentsAds;
  List<String> newZList = [];
  DocumentSnapshot usersList;

  addNewZ() async {
    var firestore = Firestore.instance;

    QuerySnapshot qusListUsers =
        await firestore.collection('ZonesIOS').getDocuments();
    if (qusListUsers != null) {
      for (int i = 0; qusListUsers.documents.length > newZList.length; i++) {
        setState(() {
          newZList.add(qusListUsers.documents[i]['Z']);
        });
      }
      if (newZList.length > 1) {
        setState(() {
          dropItemsArea = newZList;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    newZList.clear();
  }

  var productId;

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
        color: Colors.white60,
        child: Stack(overflow: Overflow.visible, children: <Widget>[
          Scaffold(
            body: Form(
              key: _formkey,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 1,
                        ),
                        Text(
                          'أضف إعلانك',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Montserrat-Arabic Regular',
                              height: 1.5),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.routeName);
                              loadingImage = false;
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 33,
                            )),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      color: Colors.grey[300],
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 4)),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, top: 3, right: 5),
                              child: Stack(
                                alignment: Alignment(1, -2),
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue),
                                      height: 60,
                                      width: 85,
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'أضف صورة',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    'Montserrat-Arabic Regular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1, 0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: deleteImage),
                                  ),
                                  loadingImage
                                      ? Opacity(
                                          opacity: 0.6,
                                          child: Container(
                                            color: Colors.white,
                                            height: 60,
                                            width: 85,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 18),
                                              child: Center(
                                                child: SpinKitFadingCircle(
                                                  color: Colors.red,
                                                  size: 70,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(),
                                ],
                              )),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              image7 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image7 != null
                                          ? Image.file(
                                              image7,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              image6 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image6 != null
                                          ? Image.file(
                                              image6,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image5 != null
                                    ? Image.file(
                                        image5,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image4 != null
                                    ? Image.file(
                                        image4,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image3 != null
                                    ? Image.file(
                                        image3,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image2 != null
                                    ? Image.file(
                                        image2,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: image != null
                                      ? Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Container(
                      width: MediaQuery.of(context).size.width - 5,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.grey[300],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // ignore: deprecated_member_use
                        setState(() {
                          choseCategory = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 26,
                            color: Colors.grey[600],
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Text(
                                'ما الذي تريد بيعه أو الإعلان عنه ؟',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    height: 1.5),
                              )),
                        ],
                      ),
                    ),
                    choseCategory
                        ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.end,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      iconSize: 30,
                                      style:
                                          TextStyle(color: Colors.green[800]),
                                      items: dropItemsCategory
                                          .map((String selectItem) {
                                        return DropdownMenuItem(
                                            value: selectItem,
                                            child: Text(selectItem));
                                      }).toList(),
                                      isExpanded: false,
                                      dropdownColor: Colors.grey[200],
                                      iconDisabledColor: Colors.green[800],
                                      iconEnabledColor: Colors.green[800],
                                      icon: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Icon(
                                            Icons.menu,
                                            size: 28,
                                          )),
                                      onChanged: (String theDate) {
                                        setState(() {
                                          dropItemsCategory2 = null;
                                          dropSelectItemCategory = null;
                                          dropSelectItemCategory2 = null;
                                          dropSelectItemCategory = theDate;
                                          category = dropSelectItemCategory;
                                          if (dropSelectItemCategory ==
                                              dropItemsCategory[2]) {
                                            dropItemsCategory2 =
                                                dropItemsMobile;
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsMobile[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[1]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsCars;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsCars[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[3]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsDevicesAndElectronics;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsDevicesAndElectronics[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[4]) {
                                            choseCategory2 = false;
                                            statusShow = false;
                                            category2 = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[5]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsOccupationsAndServices;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsOccupationsAndServices[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[6]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsHome;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsHome[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[7]) {
                                            choseCategory2 = false;
                                            statusShow = true;
                                            category2 = dropSelectItemCategory;
                                            category = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[8]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsLivestocks;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsLivestocks[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[9]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsFarming;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFarming[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[10]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsGames;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsGames[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[11]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsClothes;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsClothes[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[12]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsFood;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFood[1];
                                          }
                                        });
                                        print(category);
                                        print(category2);
                                      },
                                      value: dropSelectItemCategory,
                                      elevation: 7,
                                    ),
                                    Text(
                                      ': إختر القسم الرئيسي ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 0.5),
                                    ),
                                  ],
                                ),
                                choseCategory2
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.end,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                            iconSize: 30,
                                            style: TextStyle(
                                                color: Colors.green[800]),
                                            items: dropItemsCategory2
                                                .map((String selectItem) {
                                              return DropdownMenuItem(
                                                  value: selectItem,
                                                  child: Text(selectItem));
                                            }).toList(),
                                            isExpanded: false,
                                            dropdownColor: Colors.grey[200],
                                            iconDisabledColor:
                                                Colors.green[800],
                                            iconEnabledColor: Colors.green[800],
                                            icon: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 5),
                                                child: Icon(
                                                  Icons.menu,
                                                  size: 27,
                                                )),
                                            onChanged: (String theDate) {
                                              setState(() {
                                                dropSelectItemCategory2 =
                                                    theDate;
                                                category2 =
                                                    dropSelectItemCategory2;
                                              });
                                              print(category);
                                              print(category2);
                                            },
                                            value: dropSelectItemCategory2,
                                            elevation: 7,
                                          ),
                                          Text(
                                            ': إختر القسم الفرعي ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily:
                                                    'Montserrat-Arabic Regular',
                                                height: 0.5),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, bottom: 2, top: 2),
                          child: SizedBox(
                            height: 54,
                            width: 240,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'أدخل إسم لإعلانك';
                                }
                                return null;
                              },
                              initialValue: _initialValues['name'].toString(),
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  name: value,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  area: _editedProduct.area,
                                  phone: _editedProduct.phone,
                                  department: _editedProduct.department,
                                  category: _editedProduct.category,
                                  imagesUrl: _editedProduct.imagesUrl,
                                  status: _editedProduct.status,
                                  isFavorite: _editedProduct.isFavorite,
                                  views: _editedProduct.views,
                                  likes: _editedProduct.likes,
                                  deviceNo: _editedProduct.deviceNo,
                                  isRequest: _editedProduct.isRequest,
                                );
                              },
                              maxLines: 1,
                              maxLength: 32,
                              //controller: nameController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: '"مثال : "آيفون ٧ للبيع',
                                hintStyle: TextStyle(fontSize: 14, height: 1),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'ضع إسم للإعلان',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat-Arabic Regular',
                              height: 1),
                        ),
                      ],
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
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
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  name: _editedProduct.name,
                                  description: value,
                                  price: _editedProduct.price,
                                  area: _editedProduct.area,
                                  phone: _editedProduct.phone,
                                  department: _editedProduct.department,
                                  category: _editedProduct.category,
                                  imagesUrl: _editedProduct.imagesUrl,
                                  status: _editedProduct.status,
                                  isFavorite: _editedProduct.isFavorite,
                                  views: _editedProduct.views,
                                  likes: _editedProduct.likes,
                                  deviceNo: _editedProduct.deviceNo,
                                  isRequest: _editedProduct.isRequest,
                                );
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
                    statusShow
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              Text(
                                ': إختر الحالة جديد أم مستعمل ',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    height: 1.8),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                    title: Text(
                                      'جديد',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 0.5),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: chacked,
                                    onChanged: (value) {
                                      setState(() {
                                        chacked = value;
                                        chacked2 = false;
                                        status = 'جديد';
                                        _editedProduct = Product(
                                          id: _editedProduct.id,
                                          name: _editedProduct.name,
                                          description:
                                              _editedProduct.description,
                                          price: _editedProduct.price,
                                          area: _editedProduct.area,
                                          phone: _editedProduct.phone,
                                          department: _editedProduct.department,
                                          category: _editedProduct.category,
                                          imagesUrl: _editedProduct.imagesUrl,
                                          status: status,
                                          isFavorite: _editedProduct.isFavorite,
                                          views: _editedProduct.views,
                                          likes: _editedProduct.likes,
                                          deviceNo: _editedProduct.deviceNo,
                                          isRequest: _editedProduct.isRequest,
                                        );
                                      });
                                    },
                                  ),
                                  CheckboxListTile(
                                    title: Text(
                                      'مستعمل',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 0.5),
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: chacked2,
                                    onChanged: (value) {
                                      setState(() {
                                        chacked2 = value;
                                        chacked = false;
                                        status = 'مستعمل';
                                        _editedProduct = Product(
                                          id: _editedProduct.id,
                                          name: _editedProduct.name,
                                          description:
                                              _editedProduct.description,
                                          price: _editedProduct.price,
                                          area: _editedProduct.area,
                                          phone: _editedProduct.phone,
                                          department: _editedProduct.department,
                                          category: _editedProduct.category,
                                          imagesUrl: _editedProduct.imagesUrl,
                                          status: status,
                                          isFavorite: _editedProduct.isFavorite,
                                          views: _editedProduct.views,
                                          likes: _editedProduct.likes,
                                          deviceNo: _editedProduct.deviceNo,
                                          isRequest: _editedProduct.isRequest,
                                        );
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            DropdownButton<String>(
                              iconSize: 22,
                              style: TextStyle(color: Colors.green[800]),
                              items: dropItemsArea.map((String selectItem) {
                                return DropdownMenuItem(
                                    value: selectItem, child: Text(selectItem));
                              }).toList(),
                              isExpanded: false,
                              dropdownColor: Colors.grey[200],
                              iconDisabledColor: Colors.green[800],
                              iconEnabledColor: Colors.green[800],
                              icon: Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.menu,
                                    size: 26,
                                  )),
                              onChanged: (String theDate) {
                                setState(() {
                                  dropSelectItemArea = theDate;
                                  area = theDate;
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    area: area,
                                    phone: _editedProduct.phone,
                                    department: _editedProduct.department,
                                    category: _editedProduct.category,
                                    imagesUrl: _editedProduct.imagesUrl,
                                    status: _editedProduct.status,
                                    isFavorite: _editedProduct.isFavorite,
                                    views: _editedProduct.views,
                                    likes: _editedProduct.likes,
                                    deviceNo: _editedProduct.deviceNo,
                                    isRequest: _editedProduct.isRequest,
                                  );
                                  showAreaTextField = true;
                                });
                              },
                              value: dropSelectItemArea,
                              elevation: 7,
                            ),
                            Text(
                              'إختر المحافظة ثم أدخل منطقتك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  height: 1),
                            ),
                            showAreaTextField
                                ? SizedBox(
                                    height: 52,
                                    width: 200,
                                    child: TextFormField(
                                      controller: areaController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'أدخل منطقتك ...';
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        _editedProduct = Product(
                                          id: _editedProduct.id,
                                          name: _editedProduct.name,
                                          description:
                                              _editedProduct.description,
                                          price: _editedProduct.price,
                                          area: area,
                                          phone: _editedProduct.phone,
                                          department: _editedProduct.department,
                                          category: _editedProduct.category,
                                          imagesUrl: _editedProduct.imagesUrl,
                                          status: _editedProduct.status,
                                          isFavorite: _editedProduct.isFavorite,
                                          views: _editedProduct.views,
                                          likes: _editedProduct.likes,
                                          deviceNo: _editedProduct.deviceNo,
                                          isRequest: _editedProduct.isRequest,
                                        );
                                      },
                                      maxLength: 30,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        hintText: '... أدخل منطقتك هنا',
                                        hintStyle:
                                            TextStyle(fontSize: 15, height: 1),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            height: 30,
                            width: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 38,
                              child: TextFormField(
                                initialValue:
                                    _initialValues['price'].toString(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ' ضع سعر لإعلانك';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return ' Please provide a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return ' Please enter a number';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: double.parse(val),
                                    area: _editedProduct.area,
                                    phone: _editedProduct.phone,
                                    department: _editedProduct.department,
                                    category: _editedProduct.category,
                                    imagesUrl: _editedProduct.imagesUrl,
                                    status: _editedProduct.status,
                                    isFavorite: _editedProduct.isFavorite,
                                    views: _editedProduct.views,
                                    likes: _editedProduct.likes,
                                    deviceNo: _editedProduct.deviceNo,
                                    isRequest: _editedProduct.isRequest,
                                  );
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... أدخل السعر المطلوب ,ارقام انجليزية',
                                  hintStyle: TextStyle(fontSize: 14, height: 1),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                                onChanged: (val) {
                                  priceText = val;
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.attach_money,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 6, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 38,
                              child: TextFormField(
                                initialValue:
                                    _initialValues['phone'].toString(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '!... أدخل رقم جوالك';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    area: _editedProduct.area,
                                    phone: num.parse(val),
                                    department: _editedProduct.department,
                                    category: _editedProduct.category,
                                    imagesUrl: _editedProduct.imagesUrl,
                                    status: _editedProduct.status,
                                    isFavorite: _editedProduct.isFavorite,
                                    views: _editedProduct.views,
                                    likes: _editedProduct.likes,
                                    deviceNo: _editedProduct.deviceNo,
                                    isRequest: _editedProduct.isRequest,
                                  );
                                },
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... أدخل رقم جوالك, ارقام انجليزية',
                                  hintStyle: TextStyle(fontSize: 14, height: 1),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                                onChanged: (val) {},
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.phone_iphone,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 140,
                            height: 54,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  final isValid =
                                      _formkey.currentState.validate();
                                  _formkey.currentState.save();

                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    name: _editedProduct.name,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    area: '$area- ${areaController.text}',
                                    phone: _editedProduct.phone,
                                    status: status,
                                    deviceNo: _editedProduct.deviceNo,
                                    category: category,
                                    uid: _editedProduct.uid,
                                    department: category2,
                                    imagesUrl: urlImages,
                                    isFavorite: _editedProduct.isFavorite,
                                    isRequest: _editedProduct.isRequest,
                                    views: _editedProduct.views,
                                    likes: _editedProduct.likes,
                                  );
                                  if (urlImages.length > 0) {
                                    if (id != null) {
                                      try {
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .updateProduct(id, _editedProduct);
                                      } catch (e) {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      'An error occurred!'),
                                                  content:
                                                      Text('SomeThing Wrong'),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      child: Text('Okay!'),
                                                    )
                                                  ],
                                                ));
                                      }
                                    } else {
                                      price = double.parse(priceText);
                                      try {
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .addProduct(_editedProduct);
                                      } catch (e) {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      'An error occurred!'),
                                                  content:
                                                      Text('SomeThing Wrong'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      child: Text('Okay!'),
                                                    )
                                                  ],
                                                ));
                                      }
                                    }
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text('لا يوجد صودة'),
                                              content: Text('اضف صورة رجاءاً'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: Text('Okay!'),
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[900],
                                  child: Center(
                                    child: Text('انشر إعلانك',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontFamily:
                                                'Montserrat-Arabic Regular',
                                            height: 1,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  deleteImage() {
    setState(() {
      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      image5 = null;
      image6 = null;
      image7 = null;
      imageUrl = null;
      imageUrl2 = null;
      imageUrl3 = null;
      imageUrl4 = null;
      imageUrl5 = null;
      imageUrl6 = null;
      imageUrl7 = null;
      urlImages.clear();
    });
  }

  showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 17,
        textColor: Colors.white);
  }
}
