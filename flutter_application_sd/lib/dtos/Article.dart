class Article {
  final int id;
  String title;
  String description;
  String company;
  String category;
  final String author;
  final String? imageUrl; 
  final String? timeUnit; 
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
    this.timeUnit, 
    this.createdAt,
    this.updatedAt,
    required this.isPublic,
    required this.isAI, 
    required this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'] ?? '', 
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'],
      timeUnit: json['timeUnit'], 
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isPublic: json['public'] ?? false,
      isAI: json['ai'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'company': company,
      'author': author,
      'imageUrl': imageUrl,
      'timeUnit': timeUnit, 
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'public': isPublic,
      'ai': isAI,
    };
  }
}
