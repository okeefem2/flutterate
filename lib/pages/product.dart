import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/price_tag.dart';
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
                margin: EdgeInsets.all(10.0),
                  child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Main axis of a row is horizontal
                children: <Widget>[
                  Text(
                    _product['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  PriceTag(_product['price'].toString())
                ],
              )),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Main axis of a row is horizontal
                children: <Widget>[
                  Text(
                    _product['description'],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                    ),
                  ),
                ],
              )),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          color: Colors.purple,
                          iconSize: 35.0,
                          icon: Icon(_product['favorited'] == true
                              ? Icons.favorite
                              : Icons.favorite_border),
                          // child: Text('Details'),
                          onPressed: () {}),
                      IconButton(
                        iconSize: 35.0,
                        color: Theme.of(context).errorColor,
                        icon: Icon(Icons.delete),
                        onPressed: () => _showWarningDialog(context),
                      ),
                    ]),
                padding: EdgeInsets.all(10.0),
              ),
            ],
          )),
        ));
  }
}
