import 'package:flutter/material.dart';
import './home.dart';
import './product_list.dart';
import './product_create.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
          drawer: Drawer(
              child: Column(children: <Widget>[
            AppBar(
              automaticallyImplyLeading:
                  false, // do not infer what the first action would be
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            )
          ])),
          appBar: AppBar(
            title: Text('Manage Products'),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(icon: Icon(Icons.add)),
            ]),
          ),
          floatingActionButton:
              FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
          body: TabBarView(
            children: <Widget>[ProductCreatePage(), ProductListPage()],
          )),
      length: 2,
    );
  }
}

// Center(
//             child: Text('Manage Products Page'),
//           )
//         )
