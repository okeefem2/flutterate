import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../enums/auth_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/location_data.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;
  Timer _authTimer;
  PublishSubject<bool> _authSubject = PublishSubject();

  PublishSubject<bool> get authSubject {
    return _authSubject;
  }

  bool get isLoading {
    return _isLoading;
  }

  User get authenticatedUser {
    return _authenticatedUser;
  }

  List<Product> get products {
    return List.from(_products); // Do not return reference, IMMUTABLE
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  void selectProduct(String id) {
    print('Selecting product $id');
    _selectedProductId = id;
    if (_selectedProductId != null) {
      notifyListeners();
    }
  }

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void replaceProduct(Product product, int index) {
    _products[index] = product;
  }

  // User specific actions

  Future<Map<String, dynamic>> _authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) {
    toggleIsLoading();
    print(email);
    print(password);
    print('logging in user');
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final String authEndpoint = authMode == AuthMode.Login
        ? 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key='
        : 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=';
    return http.post('${authEndpoint}AIzaSyBokmklbEkyN2qJsb_PQVcS48edt9EbHYE',
        body: json.encode(authData),
        headers: {
          'Content-Type': 'application/json'
        }).then((http.Response response) async {
      print(json.decode(response.body));
      final Map<String, dynamic> responseData = json.decode(response.body);
      toggleIsLoading();
      if (response.statusCode != 200 && response.statusCode != 201 ||
          !responseData.containsKey('idToken')) {
        final String message = responseData['error'] != null &&
                responseData['error']['message'] != null
            ? 'Authentication Failed ${authMode == AuthMode.Login ? 'Credentials Invalid' : responseData['error']['message']}'
            : 'Authentication Failed';
        return {'success': false, 'message': message};
      }
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          authToken: responseData['idToken']);
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', responseData['idToken']);
      sharedPreferences.setString('userEmail', email);
      sharedPreferences.setString('userId', responseData['localId']);
      final int tokenExpiresIn = int.parse(responseData['expiresIn']);
      final DateTime now = DateTime.now();
      final DateTime tokenExpiration =
          now.add(Duration(seconds: tokenExpiresIn));
      sharedPreferences.setString(
          'tokenExpiration', tokenExpiration.toIso8601String());
      _authSubject.add(true);
      setAuthTimeout(tokenExpiresIn);
      return {'success': true, 'message': 'Authentication succesful'};
    }).catchError((error) =>
        {'success': false, 'message': 'Authentication failed , error: $error'});
  }

  Future<Map<String, dynamic>> login(String email, String password) {
    return _authenticate(email, password, AuthMode.Login);
  }

  Future<Map<String, dynamic>> register(String email, String password) {
    return _authenticate(email, password, AuthMode.Register);
  }

  void logout() async {
    _authTimer.cancel();
    _authenticatedUser = null;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    sharedPreferences.remove('userEmail');
    sharedPreferences.remove('userId');
    sharedPreferences.remove('tokenExpiration');
    _authSubject.add(false);
  }

  void checkToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString('token');
    if (token != null) {
      final DateTime tokenExpiration =
          DateTime.parse(sharedPreferences.getString('tokenExpiration'));
      final DateTime now = DateTime.now();
      if (DateTime.now().isAfter(tokenExpiration)) {
        _authSubject.add(true);
        setAuthTimeout(tokenExpiration.difference(now).inSeconds);
        final String email = sharedPreferences.getString('userEmail');
        final String id = sharedPreferences.getString('userId');
        _authenticatedUser = User(id: id, email: email, authToken: token);
        notifyListeners();
      }
    }
  }

  void setAuthTimeout(int time) {
    print('setting auth timeout to :$time');
    _authTimer = Timer(Duration(seconds: time), () {
      print('Automatically logging out');
      logout();
    });
  }

  // Product specific actions, these could probably be added to the products scoped model

  Future<bool> addProduct(
      {String title, String description, double price,
       String imageUrl, LocationData locationData}) {
    toggleIsLoading();
    print('adding a product');
    final Product productToSave = Product(
        title: title,
        description: description,
        price: price,
        userId: _authenticatedUser.id,
        userEmail: _authenticatedUser.email,
        imageUrl: imageUrl,
        locationLatitude: locationData.latitude,
        locationLongitude: locationData.longitude,
        locationAddress: locationData.address);
    return http
        .post(
            'https://flutterate-api.firebaseio.com/products.json?auth=${_authenticatedUser != null ? _authenticatedUser.authToken : ''}',
            body: json.encode(productToSave.toJson()))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        toggleIsLoading();
        return false;
      }
      print('Product saved!');
      final Map<String, dynamic> savedProductData = json.decode(response.body);
      final newProduct = Product(
          id: savedProductData['name'],
          title: title,
          description: description,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email,
          imageUrl: imageUrl,
          locationLatitude: locationData.latitude,
          locationLongitude: locationData.longitude,
          locationAddress: locationData.address);
      _products.add(newProduct);
      toggleIsLoading();
      return true;
    }).catchError((error) {
      toggleIsLoading();
      return false;
    });
  }

  Future<bool> removeProduct() {
    // Example async function
    print('removing');
    final removedProductId = _selectedProductId;
    _products.removeWhere((Product product) => product.id == selectedProductId);
    toggleIsLoading();
    return http
        .delete(
            'https://flutterate-api.firebaseio.com/products/$removedProductId.json?auth=${_authenticatedUser != null ? _authenticatedUser.authToken : ''}')
        .then((http.Response response) {
      toggleIsLoading();
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      return true;
    }).catchError((error) {
      toggleIsLoading();
      return false;
    });
  }

  Future<bool> updateProduct(
      {String title,
      String description,
      double price,
      String imageUrl,
      LocationData locationData}) {
        print(locationData.address);
    final int selectedProductIndex = products
        .indexWhere((Product product) => product.id == _selectedProductId);
    final oldProduct = _products[selectedProductIndex];
    if (_authenticatedUser.id != oldProduct.userId) {
      print('You do not own this product silly');
      return Future.value(false);
    }
    toggleIsLoading();
    print('replacing');
    final Product newProduct = Product(
        id: oldProduct.id,
        title: title,
        description: description,
        price: price,
        userId: oldProduct.userId,
        userEmail: oldProduct.userEmail,
        imageUrl: imageUrl,
        locationLatitude: locationData.latitude,
        locationLongitude: locationData.longitude,
        locationAddress: locationData.address);
    return http
        .put(
            'https://flutterate-api.firebaseio.com/products/${oldProduct.id}.json?auth=${_authenticatedUser != null ? _authenticatedUser.authToken : ''}',
            body: json.encode(newProduct.toJson()))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        print(response.body);
        toggleIsLoading();
        return false;
      }
      replaceProduct(newProduct, selectedProductIndex);
      toggleIsLoading();
      return true;
    }).catchError((error) {
      print('Error updating $error');
      toggleIsLoading();
      return false;
    });
  }

  Future<bool> fetchProducts([bool showLoader = false]) {
    print('fetching products');
    if (showLoader) {
      toggleIsLoading();
    }
    return http
        .get(
            'https://flutterate-api.firebaseio.com/products.json?auth=${_authenticatedUser != null ? _authenticatedUser.authToken : ''}')
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        if (showLoader) {
         toggleIsLoading();
        } else {
          notifyListeners();
        }
        return false;
      }
      final List<Product> fetchedProductList = [];
      print('Got the data');
      final Map<String, dynamic> productListData = json.decode(response.body);
      print(productListData);
      if (productListData != null) {
        productListData.forEach((String productId, dynamic productData) {
          productData['id'] = productId;
          print(productData);
          final Product product = Product.fromJson(productData, authenticatedUser.id);
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
      return true;
    }).catchError((error) {
      print('An error occurred fetching products $error');
      if (showLoader) {
        toggleIsLoading();
      }
      return false;
    });
  }
}
