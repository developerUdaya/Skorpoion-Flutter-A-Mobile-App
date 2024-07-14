import 'dart:convert';

class TrackOrderResponse {
  final String orderId;
  final String status;
  final PartnerInfo? partnerInfo;
  final OrderTimings orderTimings;
  final FareDetails fareDetails;

  TrackOrderResponse({
    required this.orderId,
    required this.status,
    required this.partnerInfo,
    required this.orderTimings,
    required this.fareDetails,
  });

  factory TrackOrderResponse.fromJson(Map<String, dynamic> json) {
    return TrackOrderResponse(
      orderId: json['order_id'],
      status: json['status'],
      partnerInfo: json['partner_info'] != null ? PartnerInfo.fromJson(json['partner_info']) : null,
      orderTimings: OrderTimings.fromJson(json['order_timings']),
      fareDetails: FareDetails.fromJson(json['fare_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'status': status,
      'partner_info': partnerInfo?.toJson(),
      'order_timings': orderTimings.toJson(),
      'fare_details': fareDetails.toJson(),
    };
  }
}

class PartnerInfo {
  final String name;
  final String vehicleNumber;
  final String vehicleType;
  final Mobile mobile;
  final Mobile? partnerSecondaryMobile;
  final Location? location;

  PartnerInfo({
    required this.name,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.mobile,
    this.partnerSecondaryMobile,
    this.location,
  });

  factory PartnerInfo.fromJson(Map<String, dynamic> json) {
    return PartnerInfo(
      name: json['name'],
      vehicleNumber: json['vehicle_number'],
      vehicleType: json['vehicle_type'],
      mobile: Mobile.fromJson(json['mobile']),
      partnerSecondaryMobile: json['partner_secondary_mobile'] != null
          ? Mobile.fromJson(json['partner_secondary_mobile'])
          : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vehicle_number': vehicleNumber,
      'vehicle_type': vehicleType,
      'mobile': mobile.toJson(),
      'partner_secondary_mobile': partnerSecondaryMobile?.toJson(),
      'location': location?.toJson(),
    };
  }
}

class Mobile {
  final String countryCode;
  final String mobileNumber;

  Mobile({
    required this.countryCode,
    required this.mobileNumber,
  });

  factory Mobile.fromJson(Map<String, dynamic> json) {
    return Mobile(
      countryCode: json['country_code'],
      mobileNumber: json['mobile_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'mobile_number': mobileNumber,
    };
  }
}

class Location {
  final double lat;
  final double long;

  Location({
    required this.lat,
    required this.long,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}

class OrderTimings {
  final int pickupTime;
  final int? orderAcceptedTime;
  final int? orderStartedTime;
  final int? orderEndedTime;

  OrderTimings({
    required this.pickupTime,
    this.orderAcceptedTime,
    this.orderStartedTime,
    this.orderEndedTime,
  });

  factory OrderTimings.fromJson(Map<String, dynamic> json) {
    return OrderTimings(
      pickupTime: json['pickup_time'],
      orderAcceptedTime: json['order_accepted_time'],
      orderStartedTime: json['order_started_time'],
      orderEndedTime: json['order_ended_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup_time': pickupTime,
      'order_accepted_time': orderAcceptedTime,
      'order_started_time': orderStartedTime,
      'order_ended_time': orderEndedTime,
    };
  }
}

class FareDetails {
  final EstimatedFareDetails? estimatedFareDetails;
  final ActualFareDetails? actualFareDetails;

  FareDetails({
    this.estimatedFareDetails,
    this.actualFareDetails,
  });

  factory FareDetails.fromJson(Map<String, dynamic> json) {
    return FareDetails(
      estimatedFareDetails: json['estimated_fare_details'] != null
          ? EstimatedFareDetails.fromJson(json['estimated_fare_details'])
          : null,
      actualFareDetails: json['actual_fare_details'] != null
          ? ActualFareDetails.fromJson(json['actual_fare_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimated_fare_details': estimatedFareDetails?.toJson(),
      'actual_fare_details': actualFareDetails?.toJson(),
    };
  }
}

class EstimatedFareDetails {
  final String currency;
  final int minorAmount;

  EstimatedFareDetails({
    required this.currency,
    required this.minorAmount,
  });

  factory EstimatedFareDetails.fromJson(Map<String, dynamic> json) {
    return EstimatedFareDetails(
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

class ActualFareDetails {
  final String currency;
  final int minorAmount;

  ActualFareDetails({
    required this.currency,
    required this.minorAmount,
  });

  factory ActualFareDetails.fromJson(Map<String, dynamic> json) {
    return ActualFareDetails(
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