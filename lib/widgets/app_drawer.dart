import 'package:ShopApp/providers/auth_provider.dart';

import 'package:ShopApp/screens/orders_screen.dart';
import 'package:ShopApp/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('More Options!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('All Products.'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My Orders.'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('My Products.'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          SizedBox(
            height: 360,
          ),
          //Divider(),
          //Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[
          IconButton(
            alignment: Alignment.bottomCenter,
            icon: Icon(Icons.exit_to_app),
            //title: Text('LogOut'),

            iconSize: 40,
            color: Theme.of(context).errorColor,
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
          SizedBox(
            height: 25,
          ),
          //Divider(),
          Text(
            'Created by: Aman Sharma.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
          
            ),
          ),
          //],
          //),
        ],
      ),
    );
  }
}
