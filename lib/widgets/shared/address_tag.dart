import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String _address;

  AddressTag(this._address);
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(8.0),
            child: Text(_address),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )),
          );
  } 
}

