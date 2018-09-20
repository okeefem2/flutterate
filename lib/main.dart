import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './product_manager.dart';
import './pages/home.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/product.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(Flutterate());
}

class Flutterate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FlutterateState();
  }
}
// final means cannot change the reference
// const makes completely immutable, cannot change the value of the var
// String a = const 'hello world'

class _FlutterateState extends State<Flutterate> {
  final List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    print('adding a product');
    print(product);
    setState(() {
      product['imageUrl'] = 'assets/your_own_empty_heart.jpg';
      _products.add(product);
    });
    print(_products);
  }

  void _removeProduct(int index) {
    print('removing');
    print(index);
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          accentColor: Colors.greenAccent,
          // fontFamily: 'Oswald' TO change the whole app theme
      ),
      home: AuthPage(),
      routes: {
        '/home': (BuildContext context) =>
            Home(_products), // Can't make it just '/' since we have a home page defined
        '/admin': (BuildContext context) => ProductsAdminPage(_products, _addProduct, _removeProduct),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        var route;
        switch (pathElements[1]) {
          case 'product':
            final int index = int.parse(pathElements[2]);
            route = MaterialPageRoute<bool>(
                builder: (BuildContext context) => Product(_products[index]));
            break;
          default:
            route = null;
            break;
        }
        return route;
      }, // Executes when routing to a named route that is not registered in routes
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) =>
            Home(_products)
        );
      }, // Executes when a route is not matched, for example when re return a null from onGenerateRoute
    ); // No new keyword needed in dart
  }
}

// Scaffold builds an empty page that can be configured
// class Flutterate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('EasyList'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.all(10.0),
//               child: RaisedButton(
//                 child: Text('Add'),
//                 onPressed: () {

//                 },
//               ),
//             ),
//             Card(
//               child: Column(
//                 children: <Widget>[
//                   Image.asset(
//                     'assets/your_own_empty_heart.jpg'
//                   ),
//                   Text('The ultimate weight loss diet')
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ); // No new keyword needed in dart
//   }
// }

// Lifecycle hooks
// Stateful vs Stateless
// Stateless accepts input into a widget that renders UI and is re rendered when input changes
// Sateful can change state internally which makes the UI re render

// Stateless (constructor, build)
// Stateful (constructor, initState, build, setState > build, didUpdateWidget - executes when input changes)
