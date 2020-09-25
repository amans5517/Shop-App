import 'package:ShopApp/providers/cart.dart' show Cart;
import 'package:ShopApp/providers/orders.dart';
import 'package:ShopApp/screens/orders_screen.dart';
import 'package:ShopApp/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    // var cartList = cart.items.value.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart!'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCart.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.itemsCart.values.toList()[i].id,
                  cart.itemsCart.keys.toList()[i],
                  cart.itemsCart.values.toList()[i].price,
                  cart.itemsCart.values.toList()[i].quantity,
                  cart.itemsCart.values.toList()[i].title),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: (_isLoading == true)
          ? CircularProgressIndicator()
          : Text('ORDER NOW.'),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.itemsCart.values.toList(),
                  widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
    );
  }
}
