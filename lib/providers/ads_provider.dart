
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../models/ads_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

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
    return _items.firstWhere((prod) => prod.uid == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
    filterByUser ? 'orderBy="creatorId"&equalTo="$userId' : '';

    var url =
        'https://souq-alfurat-89023.firebaseio.com/products.json';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
      'https://souq-alfurat-89023.firebaseio.com/userFavorite/$userId.json';
      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);

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
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    print('id = ${product.id}');
    final url =
        'https://souq-alfurat-89023.firebaseio.com/products.json';

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
      final url =
          'https://souq-alfurat-89023.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newProduct.name,
            'description': newProduct.description,
            'imageUrl': newProduct.imagesUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
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
}
