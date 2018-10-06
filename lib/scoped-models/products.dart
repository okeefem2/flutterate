import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_products.dart';
class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.favorited).toList();
    }
    return products; // Do not return reference, IMMUTABLE
  }

  Product get selectedProduct {
    return selectedProductIndex != null ? products[selectedProductIndex] : null; // This is okay because all of the stuff is final in the model
  }

  bool get showFavorites {
    return _showFavorites;
  }

  void toggleProductFavorite() {
    final bool favorite = !selectedProduct.favorited;
    updateProduct(description: selectedProduct.description,
      title: selectedProduct.title,
      price: selectedProduct.price,
      imageUrl: selectedProduct.imageUrl, favorited: favorite);
    notifyListeners();
    selectProduct(null);
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}