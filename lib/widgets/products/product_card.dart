import 'package:flutter/material.dart';
import './price_tag.dart';
import '../shared/title_default.dart';
import '../shared/address_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product _product;

  ProductCard(this._product);

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Main axis of a row is horizontal
      children: <Widget>[
        Flexible(child: TitleDefault(_product.title)),
        Flexible( child: SizedBox(
          width: 10.0,
        )),
        Flexible(child: PriceTag(_product.price.toString()))
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
            color: Colors.purple,
            iconSize: 35.0,
            icon: Icon(_product.favorited == true
                ? Icons.favorite
                : Icons.favorite_border),
            // child: Text('Details'),
            onPressed: () {
              model.selectProduct(_product.id);
              model.toggleProductFavorite();
            }),
        IconButton(
          color: Theme.of(context).accentColor,
          iconSize: 35.0,
          icon: Icon(Icons.info),
          // child: Text('Details'),
          onPressed: () => Navigator.pushNamed<bool>(
                      // Tell the type of the future
                      context,
                      '/product/' + _product.id)
                  .then((value) {
                if (value) {
                  // removeProduct(index);
                }
              }),
        )
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            child: FadeInImage(
              image: NetworkImage(_product.imageUrl),
              height: 300.0,
              fit: BoxFit.cover, // Auto zoom the image
              placeholder: AssetImage('assets/flutter.png'),
            ),
            tag: _product.id,
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              // padding: EdgeInsets.only(top: 10.0),
              // margin: EdgeInsets.symmetric(vertical: 10.0),
              child: _buildTitlePriceRow()),
          AddressTag(_product.locationAddress != null
              ? _product.locationAddress
              : 'Not Set'),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
