class ArticleUpdate {
  final int id;
   String title;
  final String description;
  final String company;
  final String author;
  final String? imageUrl; // Può essere null
  final String? timeUnit; // Cambiato a String? per gestire i valori null
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
    this.timeUnit, // Non richiesto ora
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
    'id': id?.toString() ?? '',  // Converte in stringa, se null mette una stringa vuota
    'title': title ?? '',  // Se title è null, assegna ''
    'description': description ?? '',  // Se description è null, assegna ''
    'company': company ?? '',  // Se company è null, assegna ''
    'author': author ?? '',  // Se author è null, assegna ''
    'imageUrl': imageUrl ?? '',  // Se imageUrl è null, assegna ''
    'timeUnit': timeUnit ?? '',  // Se timeUnit è null, assegna ''
    'createdAt': createdAt?.toIso8601String() ?? '',  // Se createdAt è null, assegna ''
    'updatedAt': updatedAt?.toIso8601String() ?? '',  // Se updatedAt è null, assegna ''
    'public': isPublic?.toString() ?? '',  // Se isPublic è null, assegna ''
    'ai': isAI?.toString() ?? '',  // Se isAI è null, assegna ''
  };
}

}
