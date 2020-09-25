import 'package:ShopApp/providers/auth_provider.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/product.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: products.id);
          },
          child: Hero(
            tag: products.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/dummy_image.png'),
              image: NetworkImage(products.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            products.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(products.isFavourite == true
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                products.toggleFavStatus(auth.token, auth.userId);

                // print(products.title);
                // print(products.isFavourite);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(products.id, products.title, products.price);
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to Cart!'),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.deleteSingleItem(products.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
