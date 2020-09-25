import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.title,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite});

  void _setAgain(value) {
    isFavourite = value;
    notifyListeners();
  }

  Future<void> toggleFavStatus(String authToken, String userId) async {
    final oldStatus = isFavourite;
    if (isFavourite == true) {
      isFavourite = false;
    } else {
      isFavourite = true;
    }

    notifyListeners();

    final url =
        'https://flutter-update-7aaff.firebaseio.com/userfavourites/$userId/$id.json?auth=$authToken';

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );

      if (response.statusCode >= 400) {
        _setAgain(oldStatus);
      }
    } catch (error) {
      _setAgain(oldStatus);
      //throw HttpException('An error occured while updating favourite!');
    }
  }
}
