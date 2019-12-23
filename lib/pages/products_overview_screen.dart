import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
//    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (selVal) {
                setState(() {
                  if (FilterOptions.Favourites == selVal) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) =>
                Badge(child: child, value: cart.itemCount.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
      drawer: AppDrawer(),
    );
  }
}
