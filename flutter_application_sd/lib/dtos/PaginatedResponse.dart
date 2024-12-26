class PaginatedResponse<T> {
  final List<T> data;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonModel) {
    return PaginatedResponse<T>(
      data: (json['data'] as List)
          .map((item) => fromJsonModel(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}
