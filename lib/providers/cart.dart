import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _itemCart = {};

  Map<String, CartItem> get itemsCart {
    return {..._itemCart};
  }

  int get itemCount {
    return _itemCart.length;
  }

  double get totalAmount {
    var total = 0.0;
    _itemCart.forEach(
      (key, item) {
        total += item.price * item.quantity;
      },
    );
    return total;
  }

  void deleteItem(String productId) {
    _itemCart.remove(productId);
    notifyListeners();
  }

  void addItem(String productid, String producttitle, double productprice) {
    if (_itemCart.containsKey(productid)) {
      _itemCart.update(
        productid,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _itemCart.putIfAbsent(
          productid,
          () => CartItem(
              id: DateTime.now().toString(),
              title: producttitle,
              price: productprice,
              quantity: 1));
    }
    notifyListeners();
  }

  void deleteSingleItem(String productId) {
    if (_itemCart.containsKey(productId) == false) {
      return;
    } else if (_itemCart[productId].quantity == 1) {
      _itemCart.remove(productId);
    } else
      // if (_itemCart[productId].quantity > 1) {
      _itemCart.update(
        productId,
        (existingProductItem) => CartItem(
          id: existingProductItem.id,
          title: existingProductItem.title,
          price: existingProductItem.price,
          quantity: existingProductItem.quantity - 1,
        ),
      );
    // }
    notifyListeners();
  }

  void clearCart() {
    _itemCart = {};
    notifyListeners();
  }
}
