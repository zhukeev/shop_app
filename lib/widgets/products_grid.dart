import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';


class ProductsGrid extends StatelessWidget {
  String _batteryLevel = 'Unknown battery level.';
 final bool showFavs;


  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favouriteItems : productsData.items;
    return Container(
      width: 500,
      height: 500,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
      ),
    );
  }
/*
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result =
          await ProductsGrid.platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }*/
}
