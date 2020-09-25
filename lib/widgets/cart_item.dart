import 'package:ShopApp/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String productId;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: IconButton(
          icon: Icon(
            Icons.delete,
            size: 36,
            color: Theme.of(context).primaryTextTheme.headline6.color,
          ),
          onPressed: () {},
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Are You Sure??'),
              content:
                  Text('Are you sure you want to delete this item from cart?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
        // if (direction == DismissDirection.startToEnd) {
        //   product.deleteItem(productId);
        // } else {
        //   product.deleteItem(productId);
        //   if (quantity > 1) {
        //     product.addItem(productId, title, price, quantity - 1);
        //   }
        // }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '₹$price',
                    style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ₹${(price * quantity).toStringAsFixed(2)} '),
            trailing: Text('x  $quantity'),
          ),
        ),
      ),
    );
  }
}
