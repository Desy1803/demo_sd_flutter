class ArticleResponse {
   int id;
   String title;
   String company;
   String description;
   bool isPublic;
   bool isAi;
   String date;
   String category;
   String authorUsername;
   String authorEmail;

  ArticleResponse({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.isPublic,
    required this.isAi,
    required this.date,
    required this.category,
    required this.authorUsername,
    required this.authorEmail,
  });


  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleResponse(
      id: json['id'] != null ? json['id'] as int : -1, 
      title: json['title'] as String? ?? "Untitled",
      company: json['company'] as String? ?? "Unknown",
      description: json['description'] as String? ?? "No description available.",
      isPublic: json['isPublic'] as bool? ?? false,
      isAi: json['isAi'] as bool? ?? false,
      date: json['date'] as String? ?? "Unknown date",
      category: json['category'] as String? ?? "Uncategorized",
      authorUsername: json['authorUsername'] as String? ?? "Anonymous",
      authorEmail: json['authorEmail'] as String? ?? "No email",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'isPublic': isPublic,
      'isAi': isAi,
      'date': date,
      'category': category,
      'authorUsername': authorUsername,
      'authorEmail': authorEmail,
    };
  }
}
