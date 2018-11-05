import 'package:flutter/material.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import '../widgets/shared/location_input.dart';
import '../widgets/shared/image_input.dart';
import '../models/location_data.dart';
import 'dart:io';

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
    'imageUrl': null,
    'location': null
  };

  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTextField(
      String labelText, Function callBack, Function validator,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String initialValue = '', controller}) {
        if (initialValue == null && controller.text.trim() == '') {
          controller.text = '';
        } else if (initialValue != null && controller.text.trim() == '') {
          controller.text = initialValue;
        }
    return TextFormField(
      controller:  controller,
      validator: validator,
      // initialValue: initialValue,
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

  void _onSubmit(
      Function addProduct, Function updateProduct, Function selectProduct,
      [String selectedProductId]) {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess && (_formData['imageUrl'] != null || selectedProductId != null)) { // Only allow null image if editing existing
      _formKey.currentState.save();
      // final newProduct = new Product(
      //     description: _formData['description'],
      //     title: _formData['title'],
      //     price: _formData['price'],
      //     imageUrl: _formData['imageUrl'],
      //     favorited: _formData['favorited']);\
      Future<bool> requestFinished;
      if (selectedProductId != null) {
        requestFinished = updateProduct(
            description: _descriptionTextController.text,
            title: _titleTextController.text,
            price: double.parse(_priceTextController.text),
            image: _formData['imageUrl'],
            locationData: _formData['location']);
      } else {
        requestFinished = addProduct(
            description: _descriptionTextController.text,
            title: _titleTextController.text,
            price: double.parse(_priceTextController.text),
            image: _formData['imageUrl'],
            locationData: _formData['location']);
      }
      requestFinished.then((bool success) {
        print('submitting product form');
        if (success) {
          Navigator.pushReplacementNamed(context, '/products').then((_) => selectProduct(null));
        } else {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something Went Wrong'),
              content: Text('Please Try Again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(context).pop(), // Remove the alert
                )
              ],
            );
          });
        }
      });
    }
  }

// This is just here for learning
// Perfect for making custom widgets that can react to gestures
  // Widget _buildCustomButton() {
  //   return GestureDetector(
  //       // Many on gesture event listeners here!!! YAY
  //       child: Container(
  //     color: Colors.greenAccent,
  //     child: Text('Custom Button'),
  //   ));
  // }

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
                    }, initialValue: product != null ? product.title : '', controller: _titleTextController),
                    _buildTextField('Description',
                        (String change) => _formData['description'] = change,
                        (String value) {
                      if (value.isEmpty) {
                        return 'Description is required';
                      }
                    },
                        maxLines: 3,
                        initialValue:
                            product != null ? product.description : '', controller: _descriptionTextController),
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
                            product != null ? product.price.toString() : '', controller: _priceTextController),
                    LocationInput(_setLocation, product),
                    ImageInput(_setImage, product),
                    Container(
                      // margin: EdgeInsets.all(8.0),
                      child: _buildSubmitButton(),
                    )
                  ],
                ))));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      if (model.isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return RaisedButton(
          onPressed: () => _onSubmit(model.addProduct, model.updateProduct,
              model.selectProduct, model.selectedProductId),
          child: Text('Save'));
    });
  }

  void _setLocation(LocationData locationData) {
    _formData['location'] = locationData;
  }

  void _setImage(File image) {
    _formData['imageUrl'] = image;
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

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return WillPopScope(
          onWillPop: () {
            model.selectProduct(null);
            print('back button pressed');
            Navigator.pop(context, false);
            return Future.value(false);
          }, child: model.selectedProductId == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product')),
              body: pageContent,
            )
      );
    });
  }
}
