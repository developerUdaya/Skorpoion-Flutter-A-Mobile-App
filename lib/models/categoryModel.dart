class Category{
  String id;
  String imageUrl;
  String categoryName;

  Category({
    required this.id,
    required this.imageUrl,
    required this.categoryName,
  });

  // Factory constructor to create a Category instance from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      imageUrl: json['imageUrl'],
      categoryName: json['categoryName'],
    );
  }

  // Method to convert a Category instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'categoryName': categoryName,
    };
  }

  // Override toString method to provide a readable string representation
  @override
  String toString() {
    return 'Category{id: $id, imageUrl: $imageUrl, categoryName: $categoryName}';
  }
}