import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import './pages/products.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';

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
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              accentColor: Colors.greenAccent,
              buttonColor: Colors.greenAccent
              // fontFamily: 'Oswald' TO change the whole app theme
              ),
          home: AuthPage(),
          routes: {
            '/home': (BuildContext context) =>
                ProductsPage(model), // Can't make it just '/' since we have a home page defined
            '/admin': (BuildContext context) => ProductsAdminPage(model),
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
                    builder: (BuildContext context) => ProductPage(index));
                break;
              default:
                route = null;
                break;
            }
            return route;
          }, // Executes when routing to a named route that is not registered in routes
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => ProductsPage(model));
          }, // Executes when a route is not matched, for example when re return a null from onGenerateRoute
        )); // No new keyword needed in dart
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
