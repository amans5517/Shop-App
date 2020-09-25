import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/product.dart';
import 'package:ShopApp/providers/product_provider.dart';
import 'package:ShopApp/screens/cart_screen.dart';
import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:ShopApp/widgets/badge.dart';
import 'package:ShopApp/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum filterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  final List<Product> loadedProducts = [];

  var _isInit = true;
  var _isLoading = false;
  var _showOnlyFav = false;

  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetData().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print(error);
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured!'),
                  content: Text('Something went wrong.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favourites'),
                value: filterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: filterOptions.All,
              ),
            ],
            onSelected: (filterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == filterOptions.Favourites) {
                    _showOnlyFav = true;
                  } else {
                    _showOnlyFav = false;
                  }
                },
              );
            },
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: (_isLoading == true)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFav),
    );
  }
}
