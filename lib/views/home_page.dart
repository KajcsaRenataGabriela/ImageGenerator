import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _cats = <String>[];

  @override
  void initState() {
    super.initState();
    _getImagesOfCats();
  }

  Future<void> _getImagesOfCats() async {
    const String accessKey = '2h7UzP5II_EW0RISr8CwogsZiouEnlhKLXy7szQrZXY';
    const String query = 'kittens';
    const String url = 'https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey';

    final Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;
      for (int i = 0; i < results.length; i++) {
        final Map<String, dynamic> result = results[i] as Map<String, dynamic>;
        final Map<String, dynamic> urlResult = result['urls'] as Map<String, dynamic>;
        _cats.add(urlResult['regular'] as String);
      }
      setState(() {
        //update list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: _cats.isNotEmpty
            ? ListView.builder(
                itemCount: _cats.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ListTile(title: Image.network(_cats[index]));
                })
            : const Center(
                child: CircularProgressIndicator(
                semanticsLabel: 'Loading photos',
              )));
  }
}
