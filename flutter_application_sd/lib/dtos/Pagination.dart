class Pagination {
   int size=10;
   int page=1;

  Pagination({
    required this.size,
    required this.page,
  });

   factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      size: json['size'],
      page: json['page'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'size': size.toString()?? '', 
    'page': page.toString() ?? '',  
  };
}
}