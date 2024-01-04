/// utils/fetch_quote_categories.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_quotes_app_project/models/quote_category_model.dart';

Future<List<QuoteCategory>> fetchQuoteCategories(String query) async {
  String requestUrl = 'https://api.quotable.io$query';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => QuoteCategory.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load authors');
  }
}





















