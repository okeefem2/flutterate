import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String email = '';
  String password = '';
  bool _obscurePassword = true;
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
            child: ListView( // make sure to use listview so content is scrollable
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets
                          .all(8.0) // Puts padding inside of the textField
                      ),
                  onChanged: (String change) {
                    setState(() {
                      email = change;
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
                    password = change;
                  },
                  obscureText: _obscurePassword,
                ),
                IconButton(
                  icon: Icon(_obscurePassword == true
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleObscurePassword,
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
