import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<String>> getImagesOfCats() async {
  final response = await http.get(Uri.parse(
      'https://api.unsplash.com/search/photos/?query=cats&client_id=2h7UzP5II_EW0RISr8CwogsZiouEnlhKLXy7szQrZXY'));
  if (response.statusCode == 200) {
    print(response.body);
    // Map<String, dynamic> results = jsonDecode(response.body);
    //
    // for (int i = 0; i < 2; i++) {
    //   images.add(results[i]['urls']['small'].toString());
    // }
    // return images;
    return ["", ''];
  } else {
    throw Exception('Failed to load cats');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<String>> _cats;

  @override
  void initState() {
    super.initState();
    _cats = getImagesOfCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          FutureBuilder(
              future: getImagesOfCats(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  final List<String>? list = snapshot.data;
                  return Container(
                      child: ListView.builder(
                          itemCount: list?.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Image.network(list![index]);
                          }));
                }
              })
          // ListView.builder(
          //   itemCount: _cats.length,
          //   itemBuilder: (BuildContext ctx, int index) {
          //     return Image.network(_cats[index]);
          //   }
          // ),
        ]));
  }
}
