import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function pressCallback;
  final String buttonText;
  final buttonArg;
  final Color color;
  ProductControl(this.pressCallback, this.buttonText, this.buttonArg, this.color);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      child: Text(buttonText),
      onPressed: () {
        pressCallback(buttonArg);
      },
    );
  }
}
