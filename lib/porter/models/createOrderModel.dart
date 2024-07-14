class CreateOrderRequest {
  final String requestId;
  final DeliveryInstructions deliveryInstructions;
  final PickupDetails pickupDetails;
  final DropDetails dropDetails;
  final String additionalComments;

  CreateOrderRequest({
    required this.requestId,
    required this.deliveryInstructions,
    required this.pickupDetails,
    required this.dropDetails,
    required this.additionalComments,
  });

  Map<String, dynamic> toJson() => {
    'request_id': requestId,
    'delivery_instructions': deliveryInstructions.toJson(),
    'pickup_details': pickupDetails.toJson(),
    'drop_details': dropDetails.toJson(),
    'additional_comments': additionalComments,
  };

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    return CreateOrderRequest(
      requestId: json['request_id'],
      deliveryInstructions: DeliveryInstructions.fromJson(json['delivery_instructions']),
      pickupDetails: PickupDetails.fromJson(json['pickup_details']),
      dropDetails: DropDetails.fromJson(json['drop_details']),
      additionalComments: json['additional_comments'],
    );
  }
}

class DeliveryInstructions {
  final List<Instruction> instructionsList;

  DeliveryInstructions({
    required this.instructionsList,
  });

  Map<String, dynamic> toJson() => {
    'instructions_list': instructionsList.map((e) => e.toJson()).toList(),
  };

  factory DeliveryInstructions.fromJson(Map<String, dynamic> json) {
    return DeliveryInstructions(
      instructionsList: List<Instruction>.from(
        json['instructions_list'].map((e) => Instruction.fromJson(e)),
      ),
    );
  }
}

class Instruction {
  final String type;
  final String description;

  Instruction({
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'description': description,
  };

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      type: json['type'],
      description: json['description'],
    );
  }
}

class PickupDetails {
  final Address address;

  PickupDetails({
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'address': address.toJson(),
  };

  factory PickupDetails.fromJson(Map<String, dynamic> json) {
    return PickupDetails(
      address: Address.fromJson(json['address']),
    );
  }
}

class DropDetails {
  final Address address;

  DropDetails({
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'address': address.toJson(),
  };

  factory DropDetails.fromJson(Map<String, dynamic> json) {
    return DropDetails(
      address: Address.fromJson(json['address']),
    );
  }
}

class Address {
  final String apartmentAddress;
  final String streetAddress1;
  final String streetAddress2;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final double lat;
  final double lng;
  final ContactDetails contactDetails;

  Address({
    required this.apartmentAddress,
    required this.streetAddress1,
    required this.streetAddress2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.lat,
    required this.lng,
    required this.contactDetails,
  });

  Map<String, dynamic> toJson() => {
    'apartment_address': apartmentAddress,
    'street_address1': streetAddress1,
    'street_address2': streetAddress2,
    'landmark': landmark,
    'city': city,
    'state': state,
    'pincode': pincode,
    'country': country,
    'lat': lat,
    'lng': lng,
    'contact_details': contactDetails.toJson(),
  };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      apartmentAddress: json['apartment_address'],
      streetAddress1: json['street_address1'],
      streetAddress2: json['street_address2'],
      landmark: json['landmark'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      country: json['country'],
      lat: json['lat'],
      lng: json['lng'],
      contactDetails: ContactDetails.fromJson(json['contact_details']),
    );
  }
}

class ContactDetails {
  final String name;
  final String phoneNumber;

  ContactDetails({
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone_number': phoneNumber,
  };

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(
      name: json['name'],
      phoneNumber: json['phone_number'],
    );
  }
}