import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imgUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imgUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imgUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var _showFavouritesOnly = false;

  void showFavouritesOnly() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  }

  List<Product> get items {
/*    if (_showFavouritesOnly) {
      return _items.where((prod) => prod.isFavourite).toList();
    }*/
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => id == item.id);
  }

  void updateProduct(String id, Product product) {
    var index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    var index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) {
    final url = 'https://flutter-shop-app-57f66.firebaseio.com/products.json';

    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'price': product.price,
        'id': product.id,
        'imgUrl': product.imgUrl,
        'isFavourite': product.isFavourite,
        'description': product.description,
      }),
    )
        .then((response) {
      final newProduct = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          imgUrl: product.imgUrl);

      print(newProduct.toString());
      _items.add(newProduct);
      notifyListeners();
    });
  }
}
