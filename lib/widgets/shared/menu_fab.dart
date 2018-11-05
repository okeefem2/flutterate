import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as Math;
class MenuFab extends StatefulWidget {
  final Product product;
  MenuFab(this.product);
  @override
  State<StatefulWidget> createState() {
    return _MenuFabState();
  }
}

class _MenuFabState extends State<MenuFab> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
                // What to animate
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 1.0,
                      curve: Curves.easeOut), // Animation behavior
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'email',
                  mini: true,
                  onPressed: () async {
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch email app';
                    }
                  },
                  child: Icon(
                    Icons.mail,
                    color: Theme.of(context).accentColor,
                  ),
                ))),
        Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
                // What to animate
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 0.5,
                      curve: Curves.easeOut), // Animation behavior
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'favorite',
                  mini: true,
                  onPressed: () {
                    model.toggleProductFavorite();
                  },
                  child: Icon(
                      model.selectedProduct.favorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.purple),
                ))),
        Container(
            height: 70.0,
            width: 56.0,
            child: FloatingActionButton(
              heroTag: 'options',
              onPressed: () {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.rotationZ(
                      _animationController.value * 0.5 * Math.pi
                    ),
                      child: Icon(
                        _animationController.isDismissed ? Icons.more_vert : Icons.close,
                  ));
                },
              ),
            )),
      ]);
    });
  }
}
