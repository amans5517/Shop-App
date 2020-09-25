import 'package:ShopApp/providers/product.dart';
import 'package:ShopApp/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = '/add-edit-products';
  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  var _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  var _addEditedProduct = Product(
    id: null,
    description: '',
    title: '',
    imageUrl: '',
    price: 0,
    isFavourite: false,
  );

  var _isLoading = false;

  // var _isInit = false;

  // var _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus == false) {
      if (_imageUrlController.text.startsWith('http') == false &&
          _imageUrlController.text.startsWith('https') == false) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit == false) {
  //     print(_imageUrlController.text);
  //     final productId = ModalRoute.of(context).settings.arguments as String;
  //     print('ID:' + productId);
  //     if (productId != null) {
  //       _addEditedProduct =
  //           Provider.of<ProductProvider>(context).findByid(productId);
  //       _initValues = {
  //         'title': _addEditedProduct.title,
  //         'description': _addEditedProduct.description,
  //         'imageUrl': '',
  //         'price': _addEditedProduct.price.toString(),
  //       };
  //       _imageUrlController.text = _addEditedProduct.imageUrl;

  //       // } else {
  //       //   _initValues = {
  //       //     'title': '',
  //       //     'description': '',
  //       //     'price': '',
  //       //     'imageUrl': '',
  //       //   };
  //       // }
  //     }
  //     print(_imageUrlController.text);
  //   }
  //   _isInit = true;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _formKey.currentState.validate();
    if (isValid == false) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // print('id2:' + _addEditedProduct.id);
    // if (_addEditedProduct.id != null) {
    //   Provider.of<ProductProvider>(context, listen: false)
    //       .editProduct(_addEditedProduct.id, _addEditedProduct);
    // } else {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .addproduct(_addEditedProduct);
    } catch (error) {
      await showDialog<Null>(
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
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Products.'),
        backgroundColor: Theme.of(context).accentColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: (_isLoading == true)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  // autovalidate: true,
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        //initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _addEditedProduct = Product(
                              //id: _addEditedProduct.id,
                              id: null,
                              isFavourite: _addEditedProduct.isFavourite,
                              description: _addEditedProduct.description,
                              title: value,
                              imageUrl: _addEditedProduct.imageUrl,
                              price: _addEditedProduct.price);
                        },
                        validator: (value) {
                          if (value.isEmpty == true) {
                            return 'Please enter a Value.';
                          }
                          // else if (isAlpha(value) == false) {
                          //   return 'Please enter a valid Value.';
                          // }
                          return null;
                        },
                      ),
                      TextFormField(
                        //initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty == true) {
                            return 'Please enter a Value.';
                          }
                          if (
                              // isNumeric(value) == false ||
                              double.parse(value) <= 0) {
                            return 'Please enter a valid Value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _addEditedProduct = Product(
                            //id: _addEditedProduct.id,
                            id: null,
                            isFavourite: _addEditedProduct.isFavourite,
                            description: _addEditedProduct.description,
                            title: _addEditedProduct.title,
                            imageUrl: _addEditedProduct.imageUrl,
                            price: double.parse(value),
                          );
                        },
                      ),
                      TextFormField(
                        //initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _addEditedProduct = Product(
                              //id: _addEditedProduct.id,
                              id: null,
                              isFavourite: _addEditedProduct.isFavourite,
                              description: value,
                              title: _addEditedProduct.title,
                              imageUrl: _addEditedProduct.imageUrl,
                              price: _addEditedProduct.price);
                        },
                        validator: (value) {
                          if (value.isEmpty == true) {
                            return 'Please enter a Value.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            //alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: (_imageUrlController.text.isEmpty == true ||
                                    _imageUrlController.text == ' ')
                                //imageUrl == null
                                ? Text(
                                    'Enter an URL.',
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      //imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: _initValues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              //onChanged: (value) => setState(() {}),
                              focusNode: _imageUrlFocusNode,
                              // onFieldSubmitted: (value) {
                              //   setState(() {
                              //     imageUrl = value;
                              //   });
                              // },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              onSaved: (value) {
                                _addEditedProduct = Product(
                                    //id: _addEditedProduct.id,
                                    id: null,
                                    isFavourite: _addEditedProduct.isFavourite,
                                    description: _addEditedProduct.description,
                                    title: _addEditedProduct.title,
                                    imageUrl: value,
                                    price: _addEditedProduct.price);
                              },
                              validator: (value) {
                                if (value.isEmpty == true) {
                                  return 'Please enter a Value.';
                                }
                                if (value.startsWith('http') == false &&
                                    value.startsWith('https') == false) {
                                  return 'Please enter a valid URL';
                                }
                                // if(value.endsWith('.png')==false && value.endsWith('.jpg')==false && value.endsWith('.jpeg')==false)
                                // {
                                //   return 'Please enter a valid URl';
                                // }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
