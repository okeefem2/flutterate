import 'package:flutter/material.dart';
import '../product_manager.dart';
import './products_admin.dart';

class Home extends StatelessWidget {

  final List<Map<String, dynamic>> products;

  Home(this.products);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(children: <Widget>[
        AppBar(
          automaticallyImplyLeading:
              false, // do not infer what the first action would be
          title: Text('Choose'),
        ),
        ListTile(
          title: Text('Manage Products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/admin');
          },
        )
      ])),
      appBar: AppBar(
        title: Text('Bloodstone Rituals'),
      ),
      body: ProductManager(products,
    ));
  }
}
