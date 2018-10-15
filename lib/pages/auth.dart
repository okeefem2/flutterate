import 'package:flutter/material.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../enums/auth_mode.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailTextController = new TextEditingController();
  final TextEditingController _passwordTextController = new TextEditingController();
  final TextEditingController _confirmEmailTextController = new TextEditingController();
  final TextEditingController _confirmPasswordTextController = new TextEditingController();
  // If you specify the controller on a text field you can then access the value and other stuff via this variable elsewhere
  // Like viewchild etc.
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'confirmEmail': null,
    'password': null,
    'confirmPassword': null,
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
      bool obscureText = false,
      TextEditingController controller, String initialValue}) {
    return TextFormField(
      initialValue: initialValue,
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
      controller: controller != null ? controller : new TextEditingController(),
    );
  }

  Widget _buildSwitch() {
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

  void _onSubmit(MainModel model) async {
    var validationSuccess = _formKey.currentState.validate();
    if (validationSuccess && (_authMode == AuthMode.Login || _formData['agreedToTerms'])) {
      _formKey.currentState.save();
      Map<String, dynamic> authenticationResult;
      if (_authMode == AuthMode.Login) {
        authenticationResult = await model.login(_formData['email'], _formData['password']);
      } else {
        authenticationResult = await model.register(_formData['email'], _formData['password']);
      }

      if (authenticationResult['success']) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something Went Wrong'),
              content: Text(authenticationResult['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(context).pop(), // Remove the alert
                )
              ],
            );
          }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final width = deviceWidth > 600.0 ? 400.0 : deviceWidth * 0.9;
    final Widget confirmEmailWidget = _buildTextField(
                                        'Confirm Email',
                                        (String change) => _formData['confirmEmail'] = change,
                                        (String value) {
                                          if (value != _emailTextController.text) {
                                            return 'Emails do not match';
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                            controller: _confirmEmailTextController) ;
    final Widget confirmPasswordWidget = _buildTextField(
                                        'Confirm Password',
                                        (String change) =>
                                            _formData['confirmPassword'] =
                                                change, (String value) {
                                      if (value != _passwordTextController.text) {
                                        return 'Passwords do not match';
                                      }
                                    },
                                    obscureText: _obscurePassword, controller: _confirmPasswordTextController);
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
                                        (String change) => _formData['email'] = change,
                                        (String value) {
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
                                            TextInputType.emailAddress, controller: _emailTextController),
                                    _authMode == AuthMode.Register ? confirmEmailWidget : Container(),
                                    SizedBox(height: 24.0),
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
                                    }, obscureText: _obscurePassword, controller: _passwordTextController),
                                    _authMode == AuthMode.Register ? confirmPasswordWidget : Container(),
                                    IconButton(
                                      // Visibility button
                                      icon: Icon(_obscurePassword == true
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: _toggleObscurePassword,
                                    ),
                                    _authMode == AuthMode.Register ? _buildSwitch() : Container(),
                                    FlatButton(
                                      child: Text(_authMode == AuthMode.Login
                                          ? 'Register'
                                          : 'Login'),
                                      onPressed: () {
                                        setState(() {
                                          _authMode =
                                              _authMode == AuthMode.Login
                                                  ? AuthMode.Register
                                                  : AuthMode.Login;
                                        });
                                      },
                                    ),
                                    Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: ScopedModelDescendant<MainModel>(
                                            builder: (BuildContext context,
                                                Widget child, MainModel model) {
                                          return model.isLoading ? CircularProgressIndicator() : RaisedButton(
                                              // Login button
                                              onPressed: () => _onSubmit(model),
                                              child: Text(_authMode == AuthMode.Login ? 'Login' : 'Register'));
                                        }))
                                  ],
                                ))))))));
  }
}
