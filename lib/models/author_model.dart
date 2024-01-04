/// models/author_model.dart

class Author {
  final String id;
  final String name;
  final String bio;
  final String description;
  final String link;
  final int quoteCount;
  final String slug;
  final String dateAdded;
  final String dateModified;

  Author({
    required this.id,
    required this.name,
    required this.bio,
    required this.description,
    required this.link,
    required this.quoteCount,
    required this.slug,
    required this.dateAdded,
    required this.dateModified,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'],
      name: json['name'],
      bio: json['bio'],
      description: json['description'],
      link: json['link'] ?? '',
      quoteCount: json['quoteCount'] ?? 0,
      slug: json['slug'],
      dateAdded: json['dateAdded'],
      dateModified: json['dateModified'],
    );
  }
}
















