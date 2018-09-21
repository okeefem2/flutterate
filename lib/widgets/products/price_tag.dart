import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String _price;

  PriceTag(this._price);

  @override
  Widget build(BuildContext context) {
    return Container(
                    child: Text(
                      '\$$_price',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'Oswald' // This is how we would change the font, I don't like this one though
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).accentColor,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  ),
  }
}