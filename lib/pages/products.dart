import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatelessWidget {
//TODO this could be a reusable widget with the products page
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      AppBar(
        automaticallyImplyLeading:
            false, // do not infer what the first action would be
        title: Text('Choose'),
      ),
      ListTile(
        leading: Icon(Icons.edit),
        title: Text('Manage Products'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/admin');
        },
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text('Bloodstone Rituals'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
                // Builder is called whenever the model changes
                builder:
                    (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(
                  model.showFavorites ? Icons.favorite : Icons.favorite_border
                ),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            })
          ],
        ),
        body: Products());
  }
}
