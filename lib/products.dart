import 'package:flutter/material.dart';
import './product_control.dart';

class Products extends StatelessWidget {
  final List<String> _products; // final to be immutable since stateless
  final Function removeProduct;
  Products(this.removeProduct, [this._products = const []]) {
    // Optional positional args wrapped in brackets and default values must be const
    // This is executed first in lifecycle
    // Is also called when the input changes
  }

  Widget _buildProductCard(BuildContext context, int index) {
    // Build method should not return null
    // To show nothing, return an empty Container()
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/your_own_empty_heart.jpg'),
          Text(_products[index]),
          ProductControl(removeProduct, 'Remove Propaganda', index)
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return _products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductCard,
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