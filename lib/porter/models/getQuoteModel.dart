class QuoteRequest {
  final PickupDetails pickupDetails;
  final DropDetails dropDetails;
  final Customer customer;

  QuoteRequest({
    required this.pickupDetails,
    required this.dropDetails,
    required this.customer,
  });

  Map<String, dynamic> toJson() => {
    'pickup_details': pickupDetails.toJson(),
    'drop_details': dropDetails.toJson(),
    'customer': customer.toJson(),
  };

  factory QuoteRequest.fromJson(Map<String, dynamic> json) {
    return QuoteRequest(
      pickupDetails: PickupDetails.fromJson(json['pickup_details']),
      dropDetails: DropDetails.fromJson(json['drop_details']),
      customer: Customer.fromJson(json['customer']),
    );
  }
}

class PickupDetails {
  final double lat;
  final double lng;

  PickupDetails({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  factory PickupDetails.fromJson(Map<String, dynamic> json) {
    return PickupDetails(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class DropDetails {
  final double lat;
  final double lng;

  DropDetails({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };

  factory DropDetails.fromJson(Map<String, dynamic> json) {
    return DropDetails(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Customer {
  final String name;
  final Mobile mobile;

  Customer({
    required this.name,
    required this.mobile,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'mobile': mobile.toJson(),
  };

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      mobile: Mobile.fromJson(json['mobile']),
    );
  }
}

class Mobile {
  final String countryCode;
  final String number;

  Mobile({
    required this.countryCode,
    required this.number,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'number': number,
  };

  factory Mobile.fromJson(Map<String, dynamic> json) {
    return Mobile(
      countryCode: json['country_code'],
      number: json['number'],
    );
  }
}