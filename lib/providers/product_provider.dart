import 'dart:convert';
import 'package:ShopApp/models/http_exception.dart';
import 'package:ShopApp/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String _authToken;
  final String _userId;

  ProductProvider(this._authToken, this._userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteOnly {
    return _items.where((p) => p.isFavourite == true).toList();
  }

  // Future<void> setFavourite(String id) async {

  // }

  Product findByid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString =
        (filterByUser == true) ? 'orderBy="creatorId"&equalTo="$_userId"' : ' ';
    var url =
        'https://flutter-update-7aaff.firebaseio.com/products.json?auth=$_authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      
      print(extractedData);
      if (extractedData.isEmpty) {
         _items = [];
        
         //notifyListeners();
        return;
      }
      url =
          'https://flutter-update-7aaff.firebaseio.com/userfavourites/$_userId.json?auth=$_authToken';
      final favResponse = await http.get(url);
final List<Product> prodList = [];
      extractedData.forEach((prodId, prodData) {
        prodList.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            //isFavourite: prodData['isFavourite'],
            isFavourite: json.decode(favResponse.body) == null
                ? false
                : json.decode(favResponse.body)[prodId] ?? false,
          ),
        );
        _items = prodList;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addproduct(Product product) async {
    final url =
        'https://flutter-update-7aaff.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          //'isFavourite': product.isFavourite,
          'creatorId': _userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      //items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-7aaff.firebaseio.com/products/$id.json?auth=$_authToken';
    final existingprodIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingprodIndex];
    _items.removeAt(existingprodIndex);
    notifyListeners();
    final response = await http.delete(url);

    // .then(
    //   (response) {
    if (response.statusCode >= 400) {
      _items.insert(existingprodIndex, existingProd);
      notifyListeners();
      throw HttpException('An error occured while deleting product!');
    }

    existingProd = null;

    // ).catchError((_) {

    //});
  }

  // void editProduct(String id,Product product)
  // {
  //   final prodIndex=_items.indexWhere((element) => element.id==id);
  //   print("product id:"+prodIndex.toString());
  //   if(prodIndex>=0){
  //     _items[prodIndex]=product;
  //     notifyListeners();
  //   }
  //   else
  //   {
  //     print('...');
  //   }
  // }
}
