/// utils/fetch_authors.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_quotes_app_project/models/author_model.dart';

Future<List<Author>> fetchAuthors(String query) async {
  String requestUrl = 'https://api.quotable.io$query';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['results']; /// response has results array.
    return data.map((json) => Author.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load authors');
  }
}


















