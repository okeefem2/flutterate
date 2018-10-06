import 'package:flutter/material.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'agreedToTerms': false
  };

  bool _obscurePassword = true;
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  DecorationImage _buildBackgroungImage() {
    return DecorationImage(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.dstATop),
        fit: BoxFit.cover,
        image: AssetImage('assets/szeth.jpg'));
  }

  // TODO break out the text field builder from the product page to reduce code
  Widget _buildTextField(
      String labelText, Function pressedCallback, Function validator,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return TextFormField(
      validator: validator,
      decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              EdgeInsets.all(8.0) // Puts padding inside of the textField
          ),
      onSaved: (String change) {
        pressedCallback(change);
      },
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }

  Widget buildSwitch() {
    return SwitchListTile(
      value: _formData['agreedToTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['agreedToTerms'] = value;
        });
      },
      title: Text('Weird At Last?'),
    );
  }

  void _onSubmit(MainModel model) {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess && _formData['agreedToTerms']) {
      _formKey.currentState.save();
      model.login(_formData['email'], _formData['password']);
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth > 600.0 ? 400.0 : deviceWidth * 0.9;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // do not infer what the first action would be
          title: Text('Login'),
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
                decoration: BoxDecoration(image: _buildBackgroungImage()),
                padding: EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Center(
                        child: SingleChildScrollView(
                            child: Container(
                                width: width,
                                child: Column(
                                  // make sure to use listview so content is scrollable
                                  children: <Widget>[
                                    _buildTextField(
                                        'Email',
                                        (String change) => _formData['email'] =
                                            change, (String value) {
                                      if (value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!RegExp(
                                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                          .hasMatch(value)) {
                                        return 'Email is invalid';
                                      }
                                    },
                                        keyboardType:
                                            TextInputType.emailAddress),
                                    _buildTextField(
                                        'Password',
                                        (String change) =>
                                            _formData['password'] = change,
                                        (String value) {
                                      if (value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                    }, obscureText: _obscurePassword),
                                    IconButton(
                                      // Visibility button
                                      icon: Icon(_obscurePassword == true
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: _toggleObscurePassword,
                                    ),
                                    buildSwitch(),
                                    Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: ScopedModelDescendant<MainModel>(
                                            builder: (BuildContext context,
                                                Widget child, MainModel model) {
                                          return RaisedButton(
                                              // Login button
                                              onPressed: () => _onSubmit(model),
                                              child: Text('Login'));
                                        }))
                                  ],
                                ))))))));
  }
}
