import 'package:flutter/material.dart';

// Widget for creating a raised button, color, text and press callback are all configurable
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
