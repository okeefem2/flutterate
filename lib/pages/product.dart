import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  final Map<String, dynamic> _product;

  Product(this._product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product['title'])),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(_product['imageUrl']),
          Container(
            child: Text(_product['title']),
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            child: RaisedButton(
              color: Theme.of(context).errorColor,
              child: Text('DELETE'), onPressed: () => Navigator.pop(context, true)
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ],
      )),
    );
  }
}
