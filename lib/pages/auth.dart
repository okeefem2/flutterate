import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  DecorationImage _buildBackgroungImage() {
    return DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.25), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: AssetImage('assets/szeth.jpg'));
  }

  // TODO break out the text field builder from the product page to reduce code
  Widget _buildTextField(String labelText, Function pressedCallback, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
                  decoration: InputDecoration(
                      labelText: labelText,
                      contentPadding: EdgeInsets
                          .all(8.0) // Puts padding inside of the textField
                      ),
                  onChanged: (String change) {
                    setState(pressedCallback(change));
                  },
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                );
  }

  Widget buildSwitch() {
    return SwitchListTile(
                  value: _agreedToTerms,
                  onChanged: (bool value) {
                    setState(() {
                      _agreedToTerms = value;
                    });
                  },
                  title: Text('Weird At Last?'),
                );
  }

  void _onSubmit() {
    Navigator.pushReplacementNamed(context, '/admin');
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
        body: Container(
            decoration: BoxDecoration(
                image: _buildBackgroungImage()
            ),
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Container(
                      width: width,
                      child: Column(
              // make sure to use listview so content is scrollable
              children: <Widget>[
                _buildTextField('Email', (String change) => _email = change, keyboardType: TextInputType.emailAddress),
                _buildTextField('Password', (String change) => _password = change, obscureText: _obscurePassword),
                IconButton( // Visibility button
                  icon: Icon(_obscurePassword == true
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleObscurePassword,
                ),
                buildSwitch(),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: RaisedButton( // Login button
                      onPressed: _onSubmit,
                      child: Text('Login')),
                )
              ],
            ))))));
  }
}
