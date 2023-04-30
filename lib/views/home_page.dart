import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../picture.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Picture> _pictures = <Picture>[];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getRequestedPictures(searchText: 'kittens', page: _page);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double height = MediaQuery.of(context).size.height;
    final double offset = _scrollController.position.pixels;
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (!_isLoading && maxScrollExtent - offset < 3 * height) {
      _page++;
      _getRequestedPictures(page: _page);
    }
  }

  Future<void> _getRequestedPictures({String? searchText, required int page}) async {
    setState(() => _isLoading = true);
    if (page == 1) {
      _pictures.clear();
    }
    final String query = searchText ?? _searchController.text;
    final http.Client client = http.Client();
    final Uri uri = Uri.parse('https://api.unsplash.com/search/photos?query=$query&per_page=30&page=$page');
    final http.Response response =
        await client.get(uri, headers: <String, String>{'Authorization': 'Client-ID ${dotenv.env['API_KEY']}'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;

      setState(() {
        _pictures
            .addAll(results.cast<Map<dynamic, dynamic>>().map((Map<dynamic, dynamic> json) => Picture.fromJson(json)));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          if (_isLoading)
            const Center(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
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
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _page = 1;
              _getRequestedPictures(searchText: _searchController.text, page: _page);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: const Text('Search'),
          ),
        ]),
        Expanded(
          child: _pictures.isNotEmpty
              ? GridView.builder(
                  controller: _scrollController,
                  itemCount: _pictures.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Picture picture = _pictures[index];
                    return GridTile(
                      child: Image.network(picture.urls.regular, fit: BoxFit.cover),
                    );
                  },
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.69),
                )
              : const Center(
                  child: CircularProgressIndicator(semanticsLabel: 'Loading photos'),
                ),
        ),
      ]),
    );
  }
}
