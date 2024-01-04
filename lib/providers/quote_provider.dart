/// providers/quote_provider.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/models/quote_model.dart';
import 'package:my_quotes_app_project/utils/global_states_helpers.dart';

class QuoteProvider extends ChangeNotifier {
  /// _listWithQuoteOfTheDay ===================================================
  List<Quote> _listWithQuoteOfTheDay = [];

  // Getter to access the tasks
  List<Quote> get listWithQuoteOfTheDay => _listWithQuoteOfTheDay;

 void setListWithQuoteOfTheDay(Quote quoteOfTheDay) async {
   List<Quote> list = await saveQuoteOfTheDayInTheStorageAndReturnList(quoteOfTheDay);
   _listWithQuoteOfTheDay = list;
 }
 
 void loadQuoteOfTheDayFromStorage() async {
   List<Quote> list = await getQuoteOfTheDayFromTheStorageAndReturnList();
   _listWithQuoteOfTheDay = list;
 }

  bool isListWithQuoteOfTheDayEmpty() {
    /// NOTE:- use .isEmpty instead of == []
    if(_listWithQuoteOfTheDay.isEmpty){
      debugPrint('list with quote of the day: empty');
      return true;
    } else {
      debugPrint('list with quote of the day: not empty');
      return false;
    }
  }

 /// _favQuotes ================================================================
 List<Quote> _favQuotes = [];

 List<Quote> get favQuotes => _favQuotes;

 void toggleAddRemoveAQuoteFromFavQuotes(Quote quoteToBeToggled) async {
   if (!_favQuotes.any((quote) => quote.id == quoteToBeToggled.id)) {
     _favQuotes.add(quoteToBeToggled);
     await saveFavoriteQuoteInTheStorage(_favQuotes);
     notifyListeners();
   } else {
     _favQuotes.removeWhere((quote) => quote.id == quoteToBeToggled.id);
     await saveFavoriteQuoteInTheStorage(_favQuotes);
     notifyListeners();
   }
 }

  bool favQuotesHasThisQuote(String quoteId) {
    if (_favQuotes.any((quote) => quote.id == quoteId)) {
      return true;
    }
    return false;
  }

  void loadFavQuotesFromStorage() async {
    List<Quote> list = await getFavoriteQuotesFromTheStorage();
    _favQuotes = list;
  }

  bool isFavQuotesEmpty() {
    /// NOTE:- use .isEmpty instead of == []
    if(_favQuotes.isEmpty){
      debugPrint('fav quotes: empty');
      return true;
    } else {
      debugPrint('fav quotes: not empty');
      return false;
    }
  }


}













