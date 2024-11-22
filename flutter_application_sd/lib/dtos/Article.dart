class Article {
  final int id;
  final String title;
  final String description;
  final String company;
  final String author;
  final String? imageUrl; // Può essere null
  final String? timeUnit; // Cambiato a String? per gestire i valori null
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
    this.timeUnit, // Non richiesto ora
    this.createdAt,
    this.updatedAt,
    required this.isPublic,
    required this.isAI,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'] ?? '', 
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      author: json['author'] ?? '',
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'public': isPublic,
      'ai': isAI,
    };
  }
}
