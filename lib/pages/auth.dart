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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // do not infer what the first action would be
          title: Text('Login'),
        ),
        body: Container(
            margin: EdgeInsets.all(8.0),
            child: ListView(
              // make sure to use listview so content is scrollable
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets
                          .all(8.0) // Puts padding inside of the textField
                      ),
                  onChanged: (String change) {
                    setState(() {
                      _email = change;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  onChanged: (String change) {
                    _password = change;
                  },
                  obscureText: _obscurePassword,
                ),
                IconButton(
                  icon: Icon(_obscurePassword == true
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleObscurePassword,
                ),
                SwitchListTile(
                  value: _agreedToTerms,
                  onChanged: (bool value) {
                    setState(() {
                      _agreedToTerms = value;
                    });
                  },
                  title: Text('Weird At Last?'),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/admin');
                      },
                      child: Text('Login')),
                )
              ],
            )));
  }
}
