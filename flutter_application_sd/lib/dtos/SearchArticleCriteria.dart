class SearchArticleCriteria {
  String? id;
  String? title;
  String? company;
  String? isPublic;  
  String? isAi;
  String? date;
  String? user;  
  String? category;
  String? createdAt;

  SearchArticleCriteria({
    this.id,
    this.title,
    this.company,
    this.isPublic,
    this.isAi,
    this.date,
    this.user,
    this.category,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'isPublic': isPublic,
      'isAi': isAi,
      'date': date,
      'user': user,
      'category': category
    };
  }
  
}
