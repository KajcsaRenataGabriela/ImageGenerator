import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.apiKey});
  final String title;
  final String apiKey;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _pictures = <String>[];

  @override
  void initState() {
    super.initState();
    getRequestedPictures(searchText: 'kittens', page: 1);
  }

  Future<void> getRequestedPictures({String? searchText, required int page}) async {
    _pictures.clear();
    final String query = searchText ?? _searchController.text;
    final http.Client client = http.Client();
    final Uri uri = Uri.parse('https://api.unsplash.com/search/photos?query=$query&per_page=30&page=$page');
    final http.Response response =
        await client.get(uri, headers: <String, String>{'Authorization': 'Client-ID ${widget.apiKey}'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;
      for (int i = 0; i < results.length; i++) {
        final Map<String, dynamic> result = results[i] as Map<String, dynamic>;
        final Map<String, dynamic> urlResult = result['urls'] as Map<String, dynamic>;
        _pictures.add(urlResult['regular'] as String);
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
        body: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
                child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.pinkAccent),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )))),
            TextButton(
                onPressed: () {
                  getRequestedPictures(searchText: _searchController.text, page: 1);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Search'))
          ]),
          Expanded(
              child: _pictures.isNotEmpty
                  ? GridView.builder(
                      itemCount: _pictures.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return GridTile(child: Image.network(_pictures[index], fit: BoxFit.cover));
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.69))
                  : const Center(child: CircularProgressIndicator(semanticsLabel: 'Loading photos')))
        ]));
  }
}
