class Article {
  final int id;
  final String title;
  final String description;
  final String company;
  final String author;
  final String? imageUrl;
  final String timeUnit;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPublic;
  final bool isAI;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.author,
    this.imageUrl,
    required this.timeUnit,
    this.createdAt,
    this.updatedAt,
    required this.isPublic,
    required this.isAI,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      author: json['author'],
      imageUrl: json['imageUrl'],
      timeUnit: json['timeUnit'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPublic: json['public'],
      isAI: json['ai'],        
    );
  }
}
