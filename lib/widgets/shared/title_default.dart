import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String _title;
  TitleDefault(this._title);
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: deviceWidth > 650 ? 20.0 : 16.0,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                    ),
                  );
  } 
}