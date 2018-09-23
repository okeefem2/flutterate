import 'package:flutter/material.dart';
import './price_tag.dart';
import '../shared/title_default.dart';
import '../shared/address_tag.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> _product;
  final int _productIndex;
  final Function _replaceProduct;

  ProductCard(this._product, this._productIndex, this._replaceProduct);

  Widget _buildTitlePriceRow() {
    return Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Main axis of a row is horizontal
                children: <Widget>[
                  TitleDefault(_product['title']),
                  SizedBox(
                    width: 10.0,
                  ),
                  PriceTag(_product['price'].toString())
                ],
              );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
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
                            '/product/' + _productIndex.toString())
                        .then((value) {
                      if (value) {
                        // removeProduct(index);
                      }
                    }),
              ),
              IconButton(
                color: Colors.purple,
                iconSize: 35.0,
                icon: Icon(_product['favorited'] == true ? Icons.favorite : Icons.favorite_border),
                // child: Text('Details'),
                onPressed: () { 
                  _product['favorited'] = !_product['favorited'];
                  _replaceProduct(_productIndex, _product);
                }
              ),
            ],
          );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(_product['imageUrl']),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              // padding: EdgeInsets.only(top: 10.0),
              // margin: EdgeInsets.symmetric(vertical: 10.0),
              child: _buildTitlePriceRow()),
          AddressTag('Nightvale, USA'),
          _buildActionButtons(context)
        ],
      ),
    );
  } 
}
