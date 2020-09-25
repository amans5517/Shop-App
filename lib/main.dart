import 'package:ShopApp/providers/auth_provider.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/orders.dart';
import 'package:ShopApp/providers/product_provider.dart';
import 'package:ShopApp/screens/add_edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'package:ShopApp/screens/cart_screen.dart';
import 'package:ShopApp/screens/orders_screen.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:ShopApp/screens/products_overview_screen.dart';
import 'package:ShopApp/screens/splash_screen.dart';
import 'package:ShopApp/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider('', '', []),
          update: (ctx, auth, previousProducts) => ProductProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.red[200],
            fontFamily: 'Lato',
          ),
          // home: ProductOverviewScreen(),
          home: auth.isAuth == true
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryLoginAgain(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // ProductOverviewScreen.routeName: (ctx) =>
            //     ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) =>
                auth.isAuth ? ProductDetailScreen() : AuthScreen(),
            CartScreen.routeName: (ctx) =>
                auth.isAuth ? CartScreen() : AuthScreen(),
            OrdersScreen.routeName: (ctx) =>
                auth.isAuth ? OrdersScreen() : AuthScreen(),
            UserProductScreen.routeName: (ctx) =>
                auth.isAuth ? UserProductScreen() : AuthScreen(),
            AddEditProductScreen.routeName: (ctx) =>
                auth.isAuth ? AddEditProductScreen() : AuthScreen(),
          },
        ),
      ),
    );
  }
}
