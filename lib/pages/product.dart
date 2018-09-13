import 'package:flutter/material.dart';
import 'dart:async';

// TODO start naming pages with page in it, I am confused bewtween pages and widgets sometimes
class Product extends StatelessWidget {
  final Map<String, dynamic> _product;

  Product(this._product);

  _showWarningDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Are You Sure?'),
              content:
                  Text('The Brownstone Spire Will Not Reverse Your Decision'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Destroy It'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                ),
                FlatButton(
                  child: Text('Send Me Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // widget that registers a callback listening to the back button
        onWillPop: () {
          print('back button pressed');
          // Since this is implemented, default functionality is not valid
          // We need to navigate manually now
          Navigator.pop(context, false);
          return Future
              .value(false); // This is were route guards can be implemented
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
                  child: Text('DELETE'),
                  onPressed: () => _showWarningDialog(context),
                ),
                padding: EdgeInsets.all(10.0),
              ),
            ],
          )),
        ));
  }
}
