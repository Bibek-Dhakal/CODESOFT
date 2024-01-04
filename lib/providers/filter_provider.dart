/// providers/filter_provider.dart

import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _appliedAuthorSlug = '';
  String _appliedTagSlug = '';
  String _appliedAuthorId = '';
  String _appliedTagId = '';

  String get appliedAuthorSlug => _appliedAuthorSlug;
  String get appliedTagSlug => _appliedTagSlug;
  String get appliedAuthorId => _appliedAuthorId;
  String get appliedTagId => _appliedTagId;

  emptyAppliedAuthor() {
    _appliedAuthorSlug = '';
    _appliedAuthorId = '';
    notifyListeners();
  }

  emptyAppliedTag() {
    _appliedTagSlug = '';
    _appliedTagId = '';
    notifyListeners();
  }

  toggleAuthorSelection(author) {
    if (_appliedAuthorSlug == author.slug) {
      _appliedAuthorSlug = '';
      _appliedAuthorId = '';
      notifyListeners();
    } else {
      _appliedAuthorSlug = author.slug;
      _appliedAuthorId = author.id;
      notifyListeners();
    }
  }

  toggleCategorySelection(quoteCategory) {
    if (_appliedTagSlug == quoteCategory.slug) {
      _appliedTagSlug = '';
      _appliedTagId = '';
      notifyListeners();
    } else {
      _appliedTagSlug = quoteCategory.slug;
      _appliedTagId = quoteCategory.id;
      notifyListeners();
    }
  }

  String generateQuotesQuery() {
    String query;
    if (_appliedAuthorSlug.isEmpty && _appliedTagSlug.isEmpty) {
      query = '/quotes/random?limit=20';
    }
    else if (_appliedAuthorSlug.isNotEmpty && _appliedTagSlug.isEmpty) {
      query = '/quotes?author=$_appliedAuthorSlug';
    }
    else if (_appliedAuthorSlug.isEmpty && _appliedTagSlug.isNotEmpty) {
      query = '/quotes?tags=$_appliedTagSlug';
    }
    else if (_appliedAuthorSlug.isNotEmpty && _appliedTagSlug.isNotEmpty) {
      query = '/quotes?tags=$_appliedTagSlug&&author=$_appliedAuthorSlug';
    }
    else {
      query = '/quotes/random?limit=20';
    }
    return query;
  }

}









