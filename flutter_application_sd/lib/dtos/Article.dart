class Article {
  final String title;
  final String description; 
  final String? imageUrl; 

  Article({required this.title, required this.description, this.imageUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
