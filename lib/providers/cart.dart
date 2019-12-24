import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchCarts() async {
    const url = 'https://flutter-shop-app-57f66.firebaseio.com//carts.json';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

  }

  Future<void> addItem(
    String productId,
    double price,
    String title,
  ) async {
    if (_items.containsKey(productId)) {
      // change quantity...
      CartItem existingCart = _items[productId];
      final url =
          'https://flutter-shop-app-57f66.firebaseio.com//carts/${existingCart.id}.json';

      print(existingCart);
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );

      await http.patch(url,
          body: json.encode({
            'quantity': existingCart.quantity + 1,
          }));
    } else {
      const url = 'https://flutter-shop-app-57f66.firebaseio.com//carts.json';
      try {
        final response = await http.post(url,
            body: json.encode({
              'title': title,
              'productId': productId,
              'price': price,
            }));

        _items.putIfAbsent(
          productId,
          () => CartItem(
            id: json.decode(response.body)['name'],
            title: title,
            price: price,
            quantity: 1,
          ),
        );

        notifyListeners();
      } on Exception catch (e) {
        print(e);
        throw e;
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {

    const url = 'https://flutter-shop-app-57f66.firebaseio.com//carts.json';
    http.delete(url);
    _items = {};
    notifyListeners();
  }
}
