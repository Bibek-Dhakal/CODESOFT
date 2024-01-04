/// models/quote_model.dart

class Quote {
  final String id;
  final String content;
  final String author;
  final String authorSlug;
  final int length;
  final List<String> tags;

  Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.authorSlug,
    required this.length,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'author': author,
      'authorSlug': authorSlug,
      'length': length,
      'tags': tags,
    };
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      authorSlug: json['authorSlug'] ?? '',
      length: json['length'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}




















