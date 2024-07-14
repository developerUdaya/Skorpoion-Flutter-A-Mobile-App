class Address {
  final String addressId;
  String addressType;
  String addressLine1;
  String addressLine2;
  String pincode;
  String lat;
  String lng;
  String name;
  bool isChecked;

  Address({
    required this.addressId,
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.pincode,
    required this.lat,
    required this.lng,
    required this.name,
    required this.isChecked,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['addressId'] ?? '',
      addressType: json['addressType'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      pincode: json['pincode'] ?? '',
      lat: json['lat']?? '',
      lng: json['lng']?? '',
      name: json['name']??'',
      isChecked: json['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'addressType': addressType,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'pincode': pincode,
      'lat':lat,
      'lng':lng,
      'name':name,
      'isChecked': isChecked,
    };
  }

  @override
  String toString() {
    return 'Address{addressId: $addressId,addressType: $addressType, addressLine1: $addressLine1, addressLine2: $addressLine2, pincode: $pincode, lat: $lat, lng: $lng, name: $name, isChecked: $isChecked}';
  }
}