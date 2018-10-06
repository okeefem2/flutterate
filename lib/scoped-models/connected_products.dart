import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  final List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;

  void login(String email, String password) {
    _authenticatedUser = User(id: 'all-hail', email: email, password: password);
  }

  List<Product> get products {
    return List.from(_products); // Do not return reference, IMMUTABLE
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  void addProduct({String title, String description, double price, String imageUrl}) {
    print('adding a product');
    final Product newProduct = Product(title: title,
    description: description,
    price: price,
    userId: _authenticatedUser.id,
    userEmail: _authenticatedUser.email,
    imageUrl: imageUrl);
    _products.add(newProduct);
  }

  void removeProduct() {
    print('removing');
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void updateProduct({String title, String description, double price, String imageUrl, bool favorited}) {
    print('replacing');
    final oldProduct =  _products[selectedProductIndex];
    final Product newProduct = Product(title: title,
    description: description,
    price: price,
    userId: oldProduct.userId,
    userEmail: oldProduct.userEmail,
    imageUrl: imageUrl,
    favorited:  favorited != null ? favorited : oldProduct.favorited);
    _products[selectedProductIndex] = newProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    if (_selectedProductIndex != null) {
      notifyListeners();
    }
  }
  
}