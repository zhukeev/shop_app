import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.prodId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(
          prodId,
        );
      },
      confirmDismiss: (dir){
       return showDialog(context: context,builder: (ctx)=>AlertDialog(title: Text('Are you sure ?'),content: Text('Do you want to remove the item from the cart?',),actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: Text("NO")),
          FlatButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: Text("YES")),
        ],));
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total : \$${quantity * price}'),
            trailing: Text('$quantity  x'),
          ),
        ),
      ),
      key: ValueKey(id),
    );
  }
}
