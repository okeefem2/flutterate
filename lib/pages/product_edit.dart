import 'package:flutter/material.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'favorited': false,
    'imageUrl': 'assets/your_own_empty_heart.jpg'
  };

  Widget _buildTextField(
      String labelText, Function callBack, Function validator,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String initialValue = ''}) {
    return TextFormField(
      validator: validator,
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              EdgeInsets.all(8.0) // Puts padding inside of the textField
          ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onSaved: (String value) {
        callBack(
            value); // No need for set state here for form, esp since widget does not need to be rebuilt
      },
    );
  }

  void _onSubmit(Function addProduct, Function updateProduct,
      [int selectedProductIndex]) {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess) {
      _formKey.currentState.save();
      final newProduct = new Product(
          description: _formData['description'],
          title: _formData['title'],
          price: _formData['price'],
          imageUrl: _formData['imageUrl'],
          favorited: _formData['favorited']);
      if (selectedProductIndex != null) {
        updateProduct(newProduct);
      } else {
        addProduct(newProduct);
      }
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

// This is just here for learning
// Perfect for making custom widgets that can react to gestures
  Widget _buildCustomButton() {
    return GestureDetector(
        // Many on gesture event listeners here!!! YAY
        child: Container(
      color: Colors.greenAccent,
      child: Text('Custom Button'),
    ));
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth > 600.0 ? 400.0 : deviceWidth * 0.9;
    final padding = deviceWidth - width;
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
            FocusNode()), // Form will override and handle it's own tappage
        child: Container(
            margin: EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  // ListView items always take the full available space on the screen
                  padding: EdgeInsets.symmetric(horizontal: padding / 2),
                  children: <Widget>[
                    _buildTextField(
                        'Title', (String change) => _formData['title'] = change,
                        (String value) {
                      if (value.isEmpty) {
                        return 'Title is required';
                      }
                    }, initialValue: product != null ? product.title : ''),
                    _buildTextField('Description',
                        (String change) => _formData['description'] = change,
                        (String value) {
                      if (value.isEmpty) {
                        return 'Description is required';
                      }
                    },
                        maxLines: 3,
                        initialValue:
                            product != null ? product.description : ''),
                    _buildTextField(
                        'Price',
                        (String change) => _formData['price'] = double
                            .parse(change.replaceFirst(RegExp(r','), '.')),
                        (String value) {
                      if (value.isEmpty) {
                        return 'Price is required';
                      }
                      if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$')
                          .hasMatch(value)) {
                        return 'Price must be a number';
                      }
                    },
                        keyboardType: TextInputType.number,
                        initialValue:
                            product != null ? product.price.toString() : ''),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: _buildSubmitButton(),
                    )
                  ],
                ))));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return RaisedButton(
          onPressed: () => _onSubmit(model.addProduct, model.updateProduct,
              model.selectedProductIndex),
          child: Text('Save'));
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //     child: RaisedButton(
    //       child: Text('Save'),
    //       onPressed: () {
    //         showModalBottomSheet(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return Center(child: Text('Mud Womb'));
    //             });
    //       },
    //     ));

    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product')),
              body: pageContent,
            );
    });
  }
}
