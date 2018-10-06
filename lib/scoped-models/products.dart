import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
class ProductsModel extends Model {
  final List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(_products); // Do not return reference, IMMUTABLE
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.favorited).toList();
    }
    return List.from(_products); // Do not return reference, IMMUTABLE
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    return _selectedProductIndex != null ? _products[_selectedProductIndex] : null; // This is okay because all of the stuff is final in the model
  }

  bool get showFavorites {
    return _showFavorites;
  }


  void addProduct(Product product) {
    print('adding a product');
    print(product);
    _products.add(product);
    _selectedProductIndex = null;
  }

  void removeProduct() {
    print('removing');
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void updateProduct(Product product) {
    print('replacing');
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  void toggleProductFavorite() {
    final bool favorite = !selectedProduct.favorited;
    final Product updatedProduct = new Product(
      description: selectedProduct.description,
      title: selectedProduct.title,
      price: selectedProduct.price,
      imageUrl: selectedProduct.imageUrl,
      favorited: favorite
    );
    updateProduct(updatedProduct);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}