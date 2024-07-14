class CreateOrderResponse {
  final String requestId;
  final String orderId;
  final int estimatedPickupTime;
  final FareDetails estimatedFareDetails;
  final String trackingUrl;

  CreateOrderResponse({
    required this.requestId,
    required this.orderId,
    required this.estimatedPickupTime,
    required this.estimatedFareDetails,
    required this.trackingUrl,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      requestId: json['request_id'],
      orderId: json['order_id'],
      estimatedPickupTime: json['estimated_pickup_time'],
      estimatedFareDetails: FareDetails.fromJson(json['estimated_fare_details']),
      trackingUrl: json['tracking_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'order_id': orderId,
      'estimated_pickup_time': estimatedPickupTime,
      'estimated_fare_details': estimatedFareDetails.toJson(),
      'tracking_url': trackingUrl,
    };
  }
}

class FareDetails {
  final String currency;
  final int minorAmount;

  FareDetails({required this.currency, required this.minorAmount});

  factory FareDetails.fromJson(Map<String, dynamic> json) {
    return FareDetails(
      currency: json['currency'],
      minorAmount: json['minor_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'minor_amount': minorAmount,
    };
  }
}