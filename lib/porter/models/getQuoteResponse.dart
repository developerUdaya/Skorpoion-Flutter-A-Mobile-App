class GetQuoteResponse {
  final List<Vehicle> vehicles;

  GetQuoteResponse({required this.vehicles});

  factory GetQuoteResponse.fromJson(Map<String, dynamic> json) {
    return GetQuoteResponse(
      vehicles: (json['vehicles'] as List)
          .map((vehicleJson) => Vehicle.fromJson(vehicleJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicles': vehicles.map((vehicle) => vehicle.toJson()).toList(),
    };
  }
}

class Vehicle {
  final String type;
  final Fare fare;
  final Capacity capacity;
  final Size size;
  final int? eta;

  Vehicle({
    required this.type,
    required this.fare,
    required this.capacity,
    required this.size,
    this.eta,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      type: json['type'],
      eta: json['eta'],
      fare: Fare.fromJson(json['fare']),
      capacity: Capacity.fromJson(json['capacity']),
      size: Size.fromJson(json['size']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'eta': eta,
      'fare': fare.toJson(),
      'capacity': capacity.toJson(),
      'size': size.toJson(),
    };
  }
}

class Fare {
  final String currency;
  final int minorAmount;

  Fare({required this.currency, required this.minorAmount});

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
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

class Capacity {
  final double value;
  final String unit;

  Capacity({required this.value, required this.unit});

  factory Capacity.fromJson(Map<String, dynamic> json) {
    return Capacity(
      value: json['value'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'unit': unit,
    };
  }
}

class Size {
  final Dimension length;
  final Dimension breadth;
  final Dimension height;

  Size({required this.length, required this.breadth, required this.height});

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      length: Dimension.fromJson(json['length']),
      breadth: Dimension.fromJson(json['breadth']),
      height: Dimension.fromJson(json['height']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length.toJson(),
      'breadth': breadth.toJson(),
      'height': height.toJson(),
    };
  }
}

class Dimension {
  final double value;
  final String unit;

  Dimension({required this.value, required this.unit});

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(
      value: json['value'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'unit': unit,
    };
  }
}