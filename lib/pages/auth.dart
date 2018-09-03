import 'package:flutter/material.dart';
import './home.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Please Login '),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('LOGIN'),
            onPressed: () {
              // nav to home page
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => Home()
              ));
            },
          ),
        ));
  }
}
