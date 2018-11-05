import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, this.product);
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source, maxWidth: 400.0); // maxwidth restricts image size when grabbing from the device
    setState(() {
      _imageFile = image;
    });
    widget.setImage(image);
    Navigator.pop(context);
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text('Pick an Image', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Use Camera',
                      ),
                    ],
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.smartphone),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Use Gallery',
                      ),
                    ],
                  ),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    Widget previewImage = Text('Please pick an image');
    print(widget.product);

    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        fit: BoxFit.cover,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    } else if (widget.product != null) {
      previewImage = Image.network(
        widget.product.imageUrl,
        fit: BoxFit.cover,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    }

    return Column(children: <Widget>[
      OutlineButton(
        borderSide:
            BorderSide(color: Theme.of(context).accentColor, width: 2.0),
        onPressed: () {
          _openImagePicker(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.camera_alt),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Add Image',
            ),
          ],
        ),
      ),
      SizedBox(height: 10.0,),
      previewImage
    ]);
  }
}
