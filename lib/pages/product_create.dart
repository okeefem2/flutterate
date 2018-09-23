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
  String _title = '';
  String _description = '';
  double _price = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        setState(callBack(value));
      },
    );
  }

  void _onSubmit() {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess) {
      _formKey.currentState.save();
      final Map<String, dynamic> product = {
        'title': _title,
        'description': _description,
        'price': _price,
        'favorited': false
      };
      widget.addProduct(product);
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
                _buildTextField('Title', (String change) => _title = change,
                    (String value) {
                      if (value.isEmpty) {
                        return 'Title is required';
                      }
                    }),
                _buildTextField(
                    'Description', (String change) => _description = change,
                    (String value) {
                      if (value.isEmpty) {
                        return 'Description is required';
                      }
                    }, maxLines: 3),
                _buildTextField(
                    'Price', (String change) => _price = double.parse(change.replaceFirst(RegExp(r','), '.')),
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
