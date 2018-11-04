import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/price_tag.dart';
import '../widgets/shared/title_default.dart';
import '../widgets/shared/address_tag.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import 'package:map_view/map_view.dart';

// TODO start naming pages with page in it, I am confused bewtween pages and widgets sometimes
class ProductPage extends StatelessWidget {

  void _showMap(Product product) {
    final CameraPosition cameraPosition = CameraPosition(
      Location(product.locationLatitude, product.locationLongitude),
      14.0 // Max says this works really well
    );
    final List<Marker> markers = <Marker>[
      Marker('position', 'Position', product.locationLatitude, product.locationLongitude),
    ];
    final MapView mapView = MapView();
    mapView.show(MapOptions(
      initialCameraPosition: cameraPosition,
      mapViewType: MapViewType.normal,
      title: 'Product Location',
    ), toolbarActions: [
      ToolbarAction('Close', 1)
    ]);
    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

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

  Widget _buildTitlePriceRow(String title, String price) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Main axis of a row is horizontal
      children: <Widget>[
        TitleDefault(title),
        SizedBox(
          width: 10.0,
        ),
        PriceTag(price)
      ],
    );
  }

  Widget _buildDescriptionRow(String description) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Main axis of a row is horizontal
      children: <Widget>[
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, bool favorited) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
          color: Colors.purple,
          iconSize: 35.0,
          icon:
              Icon(favorited == true ? Icons.favorite : Icons.favorite_border),
          // child: Text('Details'),
          onPressed: () {}),
      IconButton(
        iconSize: 35.0,
        color: Theme.of(context).errorColor,
        icon: Icon(Icons.delete),
        onPressed: () => _showWarningDialog(context),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        // Builder is called whenever the model changes
        builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.selectedProduct;

      return WillPopScope(
          // widget that registers a callback listening to the back button
          onWillPop: () {
            model.selectProduct(null);
            print('back button pressed');
            // Since this is implemented, default functionality is not valid
            // We need to navigate manually now
            Navigator.pop(context, false);
            return Future.value(
                false); // This is were route guards can be implemented
            // returning false in this case because we are manually calling pop, otherwise the app will try to pop again when
            // This method resolves as true
          },
          child: Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(product.imageUrl),
                  height: 300.0,
                  fit: BoxFit.cover, // Auto zoom the image
                  placeholder: AssetImage('flutter.png'),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: _buildTitlePriceRow(
                        product.title, product.price.toString())),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: _buildDescriptionRow(product.description)),
                    GestureDetector(
                      child: AddressTag(product.locationAddress != null ? product.locationAddress : 'Not Set'),
                      onTap: () {
                        _showMap(product);
                      },
                    ),
                Container(
                  child: _buildButtonRow(context, product.favorited),
                  padding: EdgeInsets.all(10.0),
                ),
              ],
            )),
          ));
    });
  }
}
