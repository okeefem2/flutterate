import 'package:flutter/material.dart';
import './product_list.dart';
import './product_edit.dart';
import '../scoped-models/main.dart';
import '../widgets/shared/logout_list_tile.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel _model;

  ProductsAdminPage(this._model);

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
              leading: Icon(Icons.shop),
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
            ),
            Divider(),
            LogoutListTile()
          ]));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: Text('Manage Products'),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                text: 'Products List',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Add Product',
                icon: Icon(Icons.add)
              ),
            ]),
          ),
          // floatingActionButton:
          //     FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
          body: TabBarView(
            children: <Widget>[
              ProductListPage(_model),
              ProductEditPage()
            ],
          )),
      length: 2,
    );
  }
}
