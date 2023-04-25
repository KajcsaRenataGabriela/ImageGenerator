import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cats from Unsplash',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: const MyHomePage(title: 'Cats from Unsplash'));
  }
}
