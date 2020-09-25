import 'dart:convert';

import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/order_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String _authToken;
  final String _userId;

  Orders(this._authToken, this._userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-update-7aaff.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final response = await http.get(url);
    //print(json.decode(response.body));

    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orders) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          datetime: DateTime.parse(orders['datetime']),
          amount: orders['amount'],
          products: (orders['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-update-7aaff.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'datetime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        datetime: timeStamp,
      ),
    );
  }
}
