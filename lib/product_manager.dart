import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  // Widget is separate from the State so needs to be immutable
  // in the widget class
  final String initialProduct;
  ProductManager({this.initialProduct = 'The Void'}) {
    // Wrapping in curlies makes it a named arg, also we can add a default val
    // Called first
  }

  @override
  State<StatefulWidget> createState() {
    // Called second
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  final List<String> _products = []; // final, can't change reference

  @override
  void initState() {
    // Called third
    super.initState(); // Best practice to call super first
    if (widget.initialProduct != null) {
      _products.add(widget.initialProduct);
    }
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    // Called whenever new external data is given
    // Provides the state of the old widget before the update
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(String product) {
    print('adding a product');
    print(product);
    setState(() {
      _products.add(product);
    });
    print(_products);
  }

  void _removeProduct(int index) {
    print('removing');
    print(index);
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Called fourth
    // Called again when the internal state changes
    // This is the ONLY method called again when internal state changes

    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(10.0),
            child: ProductControl(
                _addProduct, 'Add Propaganda', 'You cannot escape the void')),
        Expanded(
            child: Products(_removeProduct,
                _products)), // Expanded takes remaining space after other widgets
      ],
    );
  }
}
