import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './product_manager.dart';
import './pages/home.dart';
void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(Flutterate());
} 

class Flutterate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        accentColor: Colors.greenAccent
      ),
      home: Home()
    ); // No new keyword needed in dart
  }
}
// final means cannot change the reference
// const makes completely immutable, cannot change the value of the var
// String a = const 'hello world'


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