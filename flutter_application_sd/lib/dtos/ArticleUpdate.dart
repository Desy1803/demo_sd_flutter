class ArticleUpdate {
  final int id;
  String title;
  final String description;
  final String company;
  final String author;
  final String? imageUrl; 
  final String? timeUnit; 
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPublic;
  final bool isAI;

  ArticleUpdate({
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
  });

  factory ArticleUpdate.fromJson(Map<String, dynamic> json) {
    return ArticleUpdate(
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
    'id': id?.toString() ?? '', 
    'title': title ?? '',  
    'description': description ?? '',  
    'company': company ?? '',  
    'author': author ?? '',  
    'imageUrl': imageUrl ?? '',  
    'timeUnit': timeUnit ?? '',  
    'createdAt': createdAt?.toIso8601String() ?? '', 
    'updatedAt': updatedAt?.toIso8601String() ?? '',  
    'public': isPublic?.toString() ?? '',  
    'ai': isAI?.toString() ?? '', 
  };
}

}
