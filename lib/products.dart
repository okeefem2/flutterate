import 'package:flutter/material.dart';
import './product_control.dart';
import './pages/product.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>>
      _products; // final to be immutable since stateless
  Products([this._products = const []]) {
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
          Image.asset(_products[index]['imageUrl']),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              // padding: EdgeInsets.only(top: 10.0),
              // margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Main axis of a row is horizontal
                children: <Widget>[
                  Text(
                    _products[index]['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    child: Text(
                      '\$${_products[index]['price'].toString()}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).accentColor,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  ),
                ],
              )),
          // SizedBox(
          //   height: 10.0
          // ),
          // Text(_products[index]['title']),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text('Nightvale, USA'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator
                        .pushNamed<bool>(
                            // Tell the type of the future
                            context,
                            '/product/' + index.toString())
                        .then((value) {
                      if (value) {
                        // removeProduct(index);
                      }
                    }),
              ),
            ],
          )
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

// Expandable takes all of the available space
// fit determines the relative amount of space that widget takes relative to others in the same space
