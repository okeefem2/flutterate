import 'package:flutter/material.dart';
import 'dart:async';

class Product extends StatelessWidget {
  final Map<String, dynamic> _product;

  Product(this._product);
  @override
  Widget build(BuildContext context) {
    return WillPopScope( // widget that registers a callback listening to the back button
      onWillPop: () {
        print('back button pressed');
        // Since this is implemented, default functionality is not valid
        // We need to navigate manually now
        Navigator.pop(context, false);
        return Future.value(false); // This is were route guards can be implemented
        // returning false in this case because we are manually calling pop, otherwise the app will try to pop again when
        // This method resolves as true
      },
      child: Scaffold(
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
    )
    );
  }
}
