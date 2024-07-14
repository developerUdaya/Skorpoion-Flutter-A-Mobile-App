class OrderHistory {
  final String orderID;
  final String orderStatus;
  final String deliveryDate;
  final String paymentStatus;
  final String deliveredBy;
  final String deliveryPartnerContactNumber;
  final List<OrderProduct> products;

  OrderHistory({
    required this.orderID,
    required this.orderStatus,
    required this.deliveryDate,
    required this.paymentStatus,
    required this.deliveredBy,
    required this.deliveryPartnerContactNumber,
    required this.products,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List;
    List<OrderProduct> productList = productsFromJson.map((productJson) => OrderProduct.fromJson(productJson)).toList();

    return OrderHistory(
      orderID: json['orderID'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      deliveryDate: json['deliveryDate'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      deliveredBy: json['deliveredBy'] ?? '',
      deliveryPartnerContactNumber: json['deliveryPartnerContactNumber'] ?? '',
      products: productList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'orderStatus': orderStatus,
      'deliveryDate': deliveryDate,
      'paymentStatus': paymentStatus,
      'deliveredBy': deliveredBy,
      'deliveryPartnerContactNumber': deliveryPartnerContactNumber,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'OrderHistory(orderID: $orderID, orderStatus: $orderStatus, deliveryDate: $deliveryDate, paymentStatus: $paymentStatus, deliveredBy: $deliveredBy, deliveryPartnerContactNumber: $deliveryPartnerContactNumber, products: $products)';
  }
}


class OrderProduct {
  final String id;
  final String createdAt;
  final String productName;
  final int productCartQuantity;
  final int price;

  OrderProduct({
    required this.id,
    required this.createdAt,
    required this.productName,
    required this.productCartQuantity,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      productCartQuantity: json['productCartQuantity'] ?? 0,
      price: json['price'] ?? 0,
      productName: json['productName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'productCartQuantity': productCartQuantity,
      'price': price,
      'productName':productName
    };
  }

  @override
  String toString() {
    return 'OrderProduct(id: $id, createdAt: $createdAt, productCartQuantity: $productCartQuantity, price: $price,productName: $productName)';
  }
}

