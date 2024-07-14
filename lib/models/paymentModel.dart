class PaymentDetails {
  String? paymentId;
  String? orderId;
  double? amount;
  String? paymentStatus;
  String? paymentMethod;

  String? name;
  String? mobileNumber;
  String? userid;
  String? paymentDate;

  PaymentDetails({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.paymentStatus,
    required this.paymentMethod,

    required this.name,
    required this.mobileNumber,
    required this.userid,
    required this.paymentDate,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentId: json['paymentId'],
      orderId: json['orderId'],
      amount: (json['amount'] as num?)?.toDouble(),
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],

      name: json['name'],
      mobileNumber: json['mobileNumber'],
      userid: json['userid'],
      paymentDate: json['paymentDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'amount': amount?.toString(),
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,

      'name': name,
      'mobileNumber': mobileNumber,
      'userid': userid,
      'paymentDate': paymentDate,
    };
  }
}