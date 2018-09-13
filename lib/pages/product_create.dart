import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String title = '';
  String description = '';
  double price = 0.0;
  @override
  Widget build(BuildContext context) {
    // return Center(
    //     child: RaisedButton(
    //       child: Text('Save'),
    //       onPressed: () {
    //         showModalBottomSheet(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return Center(child: Text('Mud Womb'));
    //             });
    //       },
    //     ));
    return Container(
        margin: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: 'Title',
                  contentPadding: EdgeInsets
                      .all(8.0) // Puts padding inside of the textField
                  ),
              onChanged: (String change) {
                setState(() {
                  title = change;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                contentPadding: EdgeInsets.all(8.0),
              ),
              maxLines: 3,
              onChanged: (String change) {
                description = change;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
                contentPadding: EdgeInsets.all(8.0),
              ),
              keyboardType: TextInputType.number,
              onChanged: (String change) {
                price = double.parse(change);
              },
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                  onPressed: () {
                    final Map<String, dynamic> product = {
                      'title': title,
                      'description': description,
                      'price': price
                    };
                    widget.addProduct(product);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text('Save')),
            )
          ],
        ));
  }
}
