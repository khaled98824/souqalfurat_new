import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../models/ads_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> newItems = [];

  late String authToken;
  late String userId;

  getData(String auth, String uId, List<Product> products) {
    authToken = auth;
    userId = uId;
    _items = products;

    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? '?orderBy="creatorId"equalTo="$userId' : '';
    print('userId $userId');
    var url = 'https://souq-alfurat-89023.firebaseio.com/products.json';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            name: prodData['name'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: false,
            imagesUrl: prodData['imageUrl'],
            creatorId: prodData['creatorId'],
            area: prodData['area'],
            phone: prodData['phone'],
            status: prodData['status'],
            deviceNo: prodData['deviceNo'],
            category: prodData['category'],
            uid: prodData['uid'],
            department: prodData['department'],
            isRequest: prodData['isRequest'],
            views: prodData['views'],
            likes: prodData['likes'],
          ),
        );
      });
      final Iterable<Product> aList =
          loadedProducts.where((element) => element.creatorId == userId);
      _items = aList.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    print('id = ${product.id}');
    final url = 'https://souq-alfurat-89023.firebaseio.com/products.json';

    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'creatorId': userId,
            'area': product.area,
            'phone': product.phone,
            'status': product.status,
            'deviceNo': product.deviceNo,
            'category': product.category,
            'uid': product.uid,
            'department': product.department,
            'imagesUrl': product.imagesUrl,
            'isFavorite': product.isFavorite,
            'isRequest': product.isRequest,
            'views': product.views,
            'likes': product.likes,
          }));
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        name: product.name,
        description: product.description,
        imagesUrl: product.imagesUrl,
        price: product.price,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://souq-alfurat-89023.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newProduct.name,
            'description': newProduct.description,
            'price': newProduct.price,
            'creatorId': userId,
            'area': newProduct.area,
            'phone': newProduct.phone,
            'status': newProduct.status,
            'deviceNo': newProduct.deviceNo,
            'category': newProduct.category,
            'uid': newProduct.uid,
            'department': newProduct.department,
            'imagesUrl': newProduct.imagesUrl,
            'isFavorite': newProduct.isFavorite,
            'isRequest': newProduct.isRequest,
            'views': newProduct.views,
            'likes': newProduct.likes,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  Future<void> updateLikes(String id, likes, index) async {
    if (id.length >= 0) {
      final url = 'https://souq-alfurat-89023.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'likes': likes + 1,
          }));
      //fetchNewAds(false);
      newItems[index].likes = newItems[index].likes + 1;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-1d972-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingproductIndex = _items.indexWhere((prod) => prod.id == id);

    Product? existingProduct = _items[existingproductIndex];
    _items.removeAt(existingproductIndex);
    notifyListeners();

    final res = await http.delete(Uri.parse(url));

    if (res.statusCode >= 400) {
      _items.insert(existingproductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete');
    }
    existingProduct = null;
  }

  //get new Ads
  Future<void> fetchNewAds([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? '?orderBy="creatorId"equalTo="$userId' : '';
    print('userId $userId');
    var url = 'https://souq-alfurat-89023.firebaseio.com/products.json';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            name: prodData['name'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: false,
            imagesUrl: prodData['imagesUrl'],
            creatorId: prodData['creatorId'],
            area: prodData['area'],
            phone: prodData['phone'],
            status: prodData['status'],
            deviceNo: prodData['deviceNo'],
            category: prodData['category'],
            uid: prodData['uid'],
            department: prodData['department'],
            isRequest: prodData['isRequest'],
            views: prodData['views'],
            likes: prodData['likes'],
          ),
        );
      });

      newItems = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
