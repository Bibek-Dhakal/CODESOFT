/// models/quote_category_model.dart

class QuoteCategory {
  final String id;
  final String name;
  final String slug;
  final int quoteCount;
  final String dateAdded;
  final String dateModified;

  QuoteCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.quoteCount,
    required this.dateAdded,
    required this.dateModified,
  });

  factory QuoteCategory.fromJson(Map<String, dynamic> json) {
    return QuoteCategory(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      quoteCount: json['quoteCount'],
      dateAdded: json['dateAdded'],
      dateModified: json['dateModified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'quoteCount': quoteCount,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
    };
  }
}




















