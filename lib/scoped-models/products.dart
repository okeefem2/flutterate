import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.favorited).toList();
    }
    return products; // Do not return reference, IMMUTABLE
  }

  List<Product> get userProducts {
    return products != null ? products.where((Product product) => product.userId == authenticatedUser.id).toList() : [];
  }

  Product get selectedProduct {
    return selectedProductId != null
        ? products
            .firstWhere((Product product) => product.id == selectedProductId)
        : null; // This is okay because all of the stuff is final in the model
  }

  bool get showFavorites {
    return _showFavorites;
  }

  void toggleProductFavorite() async {
    final bool favorite = !selectedProduct.favorited;
    final int selectedProductIndex = products
        .indexWhere((Product product) => product.id == selectedProductId);

    final Product newProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail,
        imageUrl: selectedProduct.imageUrl,
        imagePath: selectedProduct.imagePath,
        locationAddress: selectedProduct.locationAddress,
        locationLatitude: selectedProduct.locationLatitude,
        locationLongitude: selectedProduct.locationLongitude,
        favorited: favorite);
    if (favorite) {
      print('adding user to favorite list');
      print(authenticatedUser.email);
      final http.Response response = await http.put(
          'https://flutterate-api.firebaseio.com/products/${selectedProduct.id}/favoritedUsers/${authenticatedUser.id}.json?auth=${authenticatedUser != null ? authenticatedUser.authToken : ''}',
          body: json.encode(true));
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('There was an error adding the user to the favorites list');

        // Error handling
        return;
      }
    } else {
      print('removing user from favorite list');
      print(authenticatedUser.email);
      final http.Response response = await http.delete(
          'https://flutterate-api.firebaseio.com/products/${selectedProduct.id}/favoritedUsers/${authenticatedUser.id}.json?auth=${authenticatedUser != null ? authenticatedUser.authToken : ''}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        // Error handling
        print('There was an error removing the user from the favorites list');
        return;
      }
    }
    replaceProduct(newProduct, selectedProductIndex);
    
    notifyListeners();
    print('toggling favorite complete');
    selectProduct(null);
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
