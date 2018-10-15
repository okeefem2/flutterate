import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/shared/logout_list_tile.dart';
class ProductsPage extends StatefulWidget {
  // Converted to stateful so we get the initstate hook for fetching products
  final MainModel model;
  ProductsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

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
      ),
      Divider(),
      LogoutListTile()
    ]));
  }

  Widget _buildProductList() {
    return ScopedModelDescendant<MainModel>(
        // Builder is called whenever the model changes
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(child: Products(), onRefresh: () => model.fetchProducts(false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
                // Builder is called whenever the model changes
                builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.showFavorites
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            })
          ],
        ),
        body: _buildProductList());
  }
}
