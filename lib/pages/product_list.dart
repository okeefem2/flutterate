import 'package:flutter/material.dart';
import './product_edit.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  final MainModel _model;
  ProductListPage(this._model);
  @override
    State<StatefulWidget> createState() {
      return _ProductListPageState();
    }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget._model.fetchProducts();
    super.initState();
  }

  Widget _buildEditButton(
      BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.userProducts[index].id);
        Navigator
            .of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(model.userProducts[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  print('removing product');
                  model.selectProduct(model.userProducts[index].id);
                  model.removeProduct();
                  model.selectProduct(null);
                } else if (direction == DismissDirection.startToEnd) {
                } else {}
              },
              background: Container(
                color: Colors.red,
              ),
              child: Column(children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(model.userProducts[index].imageUrl)),
                  title: Text(model.userProducts[index].title),
                  subtitle: Text('\$${model.userProducts[index].price}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ]));
        },
        itemCount: model.userProducts.length,
      );
    });
  }
}
