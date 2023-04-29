import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  // TODO(renata): put in in env
  const String apiKey = '2h7UzP5II_EW0RISr8CwogsZiouEnlhKLXy7szQrZXY';
  runApp(const MyApp(apiKey: apiKey));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.apiKey});

  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cats from Unsplash',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: MyHomePage(
          title: 'Cats from Unsplash',
          apiKey: apiKey,
        ));
  }
}
