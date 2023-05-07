import 'dart:convert';

import 'package:http/http.dart';

import '../models/index.dart';

class UnsplashApi {
  UnsplashApi(this._client, this._apiKey);

  final Client _client;
  final String _apiKey;

  Future<List<Picture>> getRequestedPictures({String? searchText, required int page}) async {
    final Uri uri = Uri.parse('https://api.unsplash.com/search/photos?query=$searchText&per_page=30&page=$page');
    final Response response = await _client.get(uri, headers: <String, String>{'Authorization': 'Client-ID $_apiKey'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;

      return results.cast<Map<dynamic, dynamic>>().map((Map<dynamic, dynamic> json) => Picture.fromJson(json)).toList();
    }
    throw StateError(response.body);
  }
}
