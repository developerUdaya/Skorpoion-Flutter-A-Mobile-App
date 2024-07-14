class Product1 {
  final String categoryName;
  final String createdAt;
  final String createdBy;
  final String imageUrl;
  final String productDescription;
  final String productName;
  final double productOption;
  final double productOriginalPrice;
  final double productPrice;
  final String productUrl;
  final int stockQuantity;
  final String id;

  Product1({
    required this.categoryName,
    required this.createdAt,
    required this.createdBy,
    required this.imageUrl,
    required this.productDescription,
    required this.productName,
    required this.productOption,
    required this.productOriginalPrice,
    required this.productPrice,
    required this.productUrl,
    required this.stockQuantity,
    required this.id,
  });

  factory Product1.fromJson(Map<String, dynamic> json) {
    return Product1(
      categoryName: json['categoryName'] ?? '',
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      productDescription: json['productDescription'] ?? '',
      productName: json['productName'] ?? '',
      productOption: (json['productOption'] ?? 0.0).toDouble(),
      productOriginalPrice: (json['productOriginalPrice'] ?? 0.0).toDouble(),
      productPrice: (json['productPrice'] ?? 0.0).toDouble(),
      productUrl: json['productUrl'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': categoryName,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
      'productDescription': productDescription,
      'productName': productName,
      'productOption': productOption,
      'productOriginalPrice': productOriginalPrice,
      'productPrice': productPrice,
      'productUrl': productUrl,
      'stockQuantity': stockQuantity,
      'id': id,
    };
  }


  @override
  String toString() {
    return 'Product1(id: $id, categoryName: $categoryName, createdAt: $createdAt, createdBy: $createdBy, imageUrl: $imageUrl, productDescription: $productDescription, productName: $productName, productOption: $productOption, productOriginalPrice: $productOriginalPrice, productPrice: $productPrice, productUrl: $productUrl, stockQuantity: $stockQuantity)';
  }
}