import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imgUrl;
  final String description;
  bool isFavourite;

  Product(
      {@required this.description,
      @required this.id,
      @required this.title,
      @required this.price,
      @required this.imgUrl,
      this.isFavourite = false});

  @override
  String toString() {
    return 'Product{id: $id, title: $title, price: $price, imgUrl: $imgUrl, description: $description, isFavourite: $isFavourite}';
  }

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
