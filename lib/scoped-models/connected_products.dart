import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void login(String email, String password) {
    _authenticatedUser = User(id: 'all-hail', email: email, password: password);
  }

  List<Product> get products {
    return List.from(_products); // Do not return reference, IMMUTABLE
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Future<Null> addProduct(
      {String title, String description, double price, String imageUrl}) {
    toggleIsLoading();
    print('adding a product');
    final Product productToSave = Product(
        title: title,
        description: description,
        price: price,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email,
        imageUrl: imageUrl);
    return http
        .post('https://flutterate-api.firebaseio.com/products.json',
            body: json.encode(productToSave.toJson()))
        .then((http.Response response) {
      print('Product saved!');
      final Map<String, dynamic> savedProductData = json.decode(response.body);
      final newProduct = Product(
          id: savedProductData['name'],
          title: title,
          description: description,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email,
          imageUrl: imageUrl);
      _products.add(newProduct);
      toggleIsLoading();
    });
  }

  Future<Null> removeProduct() {
    print('removing');
    final removedProductId = _products[selectedProductIndex].id;
    _products.removeAt(selectedProductIndex);
    toggleIsLoading();
    return http
        .delete(
            'https://flutterate-api.firebaseio.com/products/${removedProductId}.json')
        .then((http.Response response) {
      toggleIsLoading();
    });
  }

  Future<Null> updateProduct(
      {String title,
      String description,
      double price,
      String imageUrl,
      bool favorited}) {
    toggleIsLoading();
    print('replacing');
    final oldProduct = _products[selectedProductIndex];
    final Product newProduct = Product(
        id: oldProduct.id,
        title: title,
        description: description,
        price: price,
        userId: oldProduct.userId,
        userEmail: oldProduct.userEmail,
        imageUrl: imageUrl,
        favorited: favorited != null ? favorited : oldProduct.favorited);
    return http
        .put(
            'https://flutterate-api.firebaseio.com/products/${oldProduct.id}.json',
            body: json.encode(newProduct.toJson()))
        .then((http.Response response) {
      _products[selectedProductIndex] = newProduct;
      toggleIsLoading();
    });
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    if (_selectedProductIndex != null) {
      notifyListeners();
    }
  }

  Future<Null> fetchProducts([bool showLoader = false]) {
    if (showLoader) {
      toggleIsLoading();
    }
    return http
        .get('https://flutterate-api.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      print('Got the data');
      final Map<String, dynamic> productListData = json.decode(response.body);
      print(productListData);
      if (productListData != null) {
        productListData.forEach((String productId, dynamic productData) {
          productData['id'] = productId;
          print(productData);
          final Product product = Product.fromJson(productData);
          print(product.toJson());
          fetchedProductList.add(product);
        });
        _products = fetchedProductList;
      }
      if (showLoader) {
        toggleIsLoading();
      } else {
        notifyListeners();
      }
    });
  }

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
