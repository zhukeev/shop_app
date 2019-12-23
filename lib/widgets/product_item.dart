import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/product_details_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: prod.id);
          },
          child: Image.network(
            prod.imgUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                icon: Icon(
                    prod.isFavourite ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  prod.toggleFavouriteStatus();
                }),
          ),
          title: Text(
            prod.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(prod.id, prod.price, prod.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(prod.id);
                      }),
                ));
              }),
        ),
      ),
    );
  }
}
