import 'package:flutter/material.dart';
import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>>
      _products; // final to be immutable since stateless
  final Function _replaceProduct;
  Products(this._replaceProduct, [this._products = const []]) {
    // Optional positional args wrapped in brackets and default values must be const
    // This is executed first in lifecycle
    // Is also called when the input changes
  }

  Widget _buildProductList() {
    return _products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => 
              ProductCard(_products[index], index, _replaceProduct),
            itemCount: _products.length,
          )
        : Center(
            child: Text('No Propaganda Here! Contact The City Council...'));
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
    return _buildProductList();
  }
}

// Expandable takes all of the available space
// fit determines the relative amount of space that widget takes relative to others in the same space
