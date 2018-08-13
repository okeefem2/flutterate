import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function pressCallback;
  final String buttonText;
  final buttonArg;
  ProductControl(this.pressCallback, this.buttonText, this.buttonArg);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      child: Text(buttonText),
      onPressed: () {
        pressCallback(buttonArg);
      },
    );
  }
}
