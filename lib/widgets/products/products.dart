import 'package:flutter/material.dart';
import '../../product_control.dart';
import '../../pages/product.dart';
import './price_tag.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>>
      _products; // final to be immutable since stateless
  final Function replaceProduct;
  Products(this.replaceProduct, [this._products = const []]) {
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
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
                  PriceTag(_products[index]['price'].toString())
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
              IconButton(
                color: Theme.of(context).accentColor,
                iconSize: 35.0,
                icon: Icon(Icons.info),
                // child: Text('Details'),
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
              IconButton(
                color: Colors.purple,
                iconSize: 35.0,
                icon: Icon(_products[index]['favorited'] == true ? Icons.favorite : Icons.favorite_border),
                // child: Text('Details'),
                onPressed: () { 
                  _products[index]['favorited'] = !_products[index]['favorited'];
                  replaceProduct(index, _products[index]);
                }
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
