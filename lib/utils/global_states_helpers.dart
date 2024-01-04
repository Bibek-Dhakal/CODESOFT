/// utils/global_state_helpers.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Quote>> saveQuoteOfTheDayInTheStorageAndReturnList(Quote quoteOfTheDay) async {
  try {
    // SAVE IN THE STORAGE (DATE TIME TOO).
    final prefs = await SharedPreferences.getInstance();
    DateTime currentDate = DateTime.now();
    String dateString = currentDate.toIso8601String();
    final encodedDateString = json.encode(dateString);
    await prefs.setString('dateTimeWhenLastSavedQuoteOfTheDay', encodedDateString);
    final jsonQuoteOfTheDay = quoteOfTheDay.toJson();
    final encodedJsonQuoteOfTheDay = json.encode(jsonQuoteOfTheDay);
    await prefs.setString('quoteOfTheDay', encodedJsonQuoteOfTheDay);
    // PUT OBJECT IN A LIST AND RETURN THE LIST.
    List<Quote> listWithQuoteOfTheDay = [];
    listWithQuoteOfTheDay.add(quoteOfTheDay);
    return listWithQuoteOfTheDay;
  }
  catch (e) {
    debugPrint('Error saving quote of the day: $e');
    return [];
  }
}

Future<List<Quote>> getQuoteOfTheDayFromTheStorageAndReturnList() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the saved date string
    final encodedDateString = prefs.getString('dateTimeWhenLastSavedQuoteOfTheDay');

    // Check if a date string is present and not empty
    if (encodedDateString != null && encodedDateString.isNotEmpty) {
      final dateString = json.decode(encodedDateString);
      final DateTime lastDateTime = DateTime.parse(dateString);
      final currentDate = DateTime.now();

      // Calculate the difference in seconds
      int secondsDifference = currentDate.difference(lastDateTime).inSeconds;

      // Check if more than 24 hours have passed since the last saved quote
      if (secondsDifference > 86400) {
        // Clear stored data and mark for fetching a new quote
        await prefs.remove('dateTimeWhenLastSavedQuoteOfTheDay');
        await prefs.remove('quoteOfTheDay');
        debugPrint('more than 1 day passed, so removed last quote of the day form the storage');
        return [];
      }
      // Retrieve and decode the saved quote
      final encodedQuote = prefs.getString('quoteOfTheDay');

      // Check if a quote is present and not empty
      if (encodedQuote != null && encodedQuote.isNotEmpty) {
        final jsonQuoteOfTheDay = json.decode(encodedQuote);
        final quoteOfTheDay = Quote.fromJson(jsonQuoteOfTheDay);
        debugPrint('got quote of the day from storage.');
        List<Quote> listWithQuoteOfTheDay = [];
        listWithQuoteOfTheDay.add(quoteOfTheDay);
        return listWithQuoteOfTheDay;
      }
      debugPrint('last quote of the day not found in the storage');
      return [];
    }
    debugPrint('last date of quote of the day not found in storage');
    return [];
  }
  catch(e) {
    debugPrint('error getting quote of the day from storage: $e');
    return [];
  }
}

Future<void> saveFavoriteQuoteInTheStorage(List<Quote> favoriteQuotes) async {
  // SAVE IN THE STORAGE.
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonFavoriteQuotes = favoriteQuotes.map((quote) => quote.toJson()).toList();
    final encodedJsonFavoriteQuotes = json.encode(jsonFavoriteQuotes);
    await prefs.setString('favoriteQuotes', encodedJsonFavoriteQuotes);
  }
  catch (e) {
  debugPrint('Error saving favorite quotes: $e');
  }
}

Future<List<Quote>> getFavoriteQuotesFromTheStorage() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve and decode the saved favorite quotes.
    final encodedFavoriteQuotes = prefs.getString('favoriteQuotes');
    // Check if favorite quotes are present and not empty
    if (encodedFavoriteQuotes != null && encodedFavoriteQuotes.isNotEmpty) {
      /// Don't MISS List<dynamic>
      final List<dynamic> jsonFavoriteQuotes = json.decode(encodedFavoriteQuotes);
      final favoriteQuotes = jsonFavoriteQuotes.map((jsonQuote) => Quote.fromJson(jsonQuote)).toList();
      debugPrint('got favorite quotes from storage.');
      return favoriteQuotes;
    }
    debugPrint('favorite quotes not found in the storage');
    return [];
  }
  catch (e) {
    debugPrint('error getting fav quotes from the storage: $e');
    return [];
  }
}




















