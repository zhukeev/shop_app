import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/edit_product.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_list.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (_, i) => Column(
                  children: <Widget>[
                    ProductsList(
                      productData.items[i].title,
                      productData.items[i].imgUrl,
                      productData.items[i].id,
                    ),
                    Divider(),
                  ],
                )),
      ),
      drawer: AppDrawer(),
    );
  }
}
