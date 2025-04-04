import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(RollMastersApp());
}

class RollMastersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Masters',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomePage(),
    );
  }
}