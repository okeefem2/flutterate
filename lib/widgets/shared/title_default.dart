import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String _title;
  TitleDefault(this._title);
  @override
  Widget build(BuildContext context) {
    return Text(
                    _title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                    ),
                  );
  } 
}