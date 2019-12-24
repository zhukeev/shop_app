import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-shop-app-57f66.firebaseio.com//products/$id.json';

    final response = await http.patch(url,
        body: json.encode({
          'isFavorite': isFavorite,
        }));

    if (response.statusCode > 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpsException('Could not delete product.');
    }

  }
}
