import 'package:flutter/material.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
class Products extends StatelessWidget {
  // Removed after using scoped model
  // final List<Product>
  //     _products; // final to be immutable since stateless
  // final Function _replaceProduct;
  // Products(this._replaceProduct, [this._products = const []]) {
  //   // Optional positional args wrapped in brackets and default values must be const
  //   // This is executed first in lifecycle
  //   // Is also called when the input changes
  // }

  Widget _buildProductList(List<Product> products) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => 
              ProductCard(products[index], index),
            itemCount: products.length,
          )
        : Center(
            child: Text('No Products Found'));
  }

  @override
  build(context) {
    print('building the products!');
    // This is executed second in lifecycle
    // Is also called when the input changes
    // Use a column if things are on top of each other but scrolling is not needed
    // return Column(
    // Note that list views need to be in a container with a defined height
    // return ListView(
    //   children: _products.map((product) => Card(
    //     child: Column(
    //       children: <Widget>[
    //           Image.asset(
    //             'assets/your_own_empty_heart.jpg'
    //           ),
    //           Text(product),
    //           ProductControl(removeProduct, 'Remove Propaganda')
    //         ],
    //       ),
    //     )
    //   ).toList(),
    // );
    return ScopedModelDescendant<MainModel>(
      // Builder is called whenever the model changes
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}

// Expandable takes all of the available space
// fit determines the relative amount of space that widget takes relative to others in the same space
