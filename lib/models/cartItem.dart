class CartItem {
  final String id;
  final String createdAt;
  int productCartQuantity;

  CartItem({
    required this.id,
    required this.createdAt,
    required this.productCartQuantity,
  });

  factory CartItem.fromJson(Map<dynamic, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      createdAt: '',
      productCartQuantity: json['productCartQuantity'] ?? 0,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'productCartQuantity': productCartQuantity,
    };
  }

  @override
  String toString() {
    return 'CartItem(id: $id, createdAt: $createdAt, productCartQuantity: $productCartQuantity)';
  }
}
