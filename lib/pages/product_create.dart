import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;
  ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
        'title': null,
        'description': null,
        'price': null,
        'favorited': false
      };

  Widget _buildTextField(
      String labelText, Function callBack, Function validator,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      validator: validator,
      decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              EdgeInsets.all(8.0) // Puts padding inside of the textField
          ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onSaved: (String value) {
        callBack(value); // No need for set state here for form, esp since widget does not need to be rebuilt
      },
    );
  }

  void _onSubmit() {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess) {
      _formKey.currentState.save();
      widget.addProduct(_formData);
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth > 600.0 ? 400.0 : deviceWidth * 0.9;
    final padding = deviceWidth - width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()), // Form will override and handle it's own tappage
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: ListView(
              // ListView items always take the full available space on the screen
              padding: EdgeInsets.symmetric(horizontal: padding / 2),
              children: <Widget>[
                _buildTextField('Title', (String change) => _formData['title'] = change,
                    (String value) {
                      if (value.isEmpty) {
                        return 'Title is required';
                      }
                    }),
                _buildTextField(
                    'Description', (String change) => _formData['description'] = change,
                    (String value) {
                      if (value.isEmpty) {
                        return 'Description is required';
                      }
                    }, maxLines: 3),
                _buildTextField(
                    'Price', (String change) => _formData['price'] = double.parse(change.replaceFirst(RegExp(r','), '.')),
                    (String value) {
                      if (value.isEmpty) {
                        return 'Price is required';
                      }
                      if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
                        return 'Price must be a number';
                      }
                    }, keyboardType: TextInputType.number),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child:
                      RaisedButton(onPressed: _onSubmit, child: Text('Save')),
                )
              ],
            ))));
  }
}
