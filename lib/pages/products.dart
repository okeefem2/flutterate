import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

class Home extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function replaceProduct;

  Home(this.products, this.replaceProduct);

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
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => {},
            )
          ],
        ),
        body: Products(replaceProduct, products));
  }
}
