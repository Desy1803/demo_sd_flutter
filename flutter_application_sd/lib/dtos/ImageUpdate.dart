class ImageUpdate {
  final int id;
  final String? imageUrl; 

  ImageUpdate({
    required this.id,
    this.imageUrl,
  });

  factory ImageUpdate.fromJson(Map<String, dynamic> json) {
    return ImageUpdate(
      id: json['id'],
      imageUrl: json['imageUrl'],
      
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id?.toString() ?? '', 
    'imageUrl': imageUrl ?? '',  
  };
}

}
