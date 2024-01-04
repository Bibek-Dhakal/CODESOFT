/// utils/fetch_quotes.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';

Future<List<Quote>> fetchQuotes(String query, bool isNewQuoteOfTheDayToBeFetched, context, isFiltered) async {
  String requestUrl = 'https://api.quotable.io$query';
  try {
    final http.Response response = await http.get(
      Uri.parse(requestUrl),
    );

    if (response.statusCode == 200) {
      // Parse the response JSON array into a list of Quote objects
      final List<dynamic> quoteJsonList = isFiltered
          ? json.decode(response.body)['results']
          : json.decode(response.body);

      final List<Quote> quotes = quoteJsonList.map((json) => Quote.fromJson(json)).toList();

      if(isNewQuoteOfTheDayToBeFetched){
        var quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
        quoteProvider.setListWithQuoteOfTheDay(quotes[0]);
        debugPrint(quotes[0].content);
      }
      return quotes;
    } else {
      // Handle the case when the request fails
      throw Exception('Failed to load quotes');
    }
  } catch (error) {
    // Handle other errors that might occur during the request
    throw Exception('Error: $error');
  }
}

Future<Quote> fetchSingleQuoteByIdAndReturnItInAList(String query) async {
  String requestUrl = 'https://api.quotable.io$query';
  try {
    final http.Response response = await http.get(
      Uri.parse(requestUrl),
    );

    if (response.statusCode == 200) {
      // Parse the response JSON into a Quote object.
      final dynamic quoteJson = json.decode(response.body);
      final Quote quote = Quote.fromJson(quoteJson);

      return quote;
    } else {
      // Handle the case when the request fails
      throw Exception('Failed to load single quote');
    }
  } catch (error) {
    // Handle other errors that might occur during the request
    throw Exception('Error: $error');
  }
}










