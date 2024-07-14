import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectb/models/addressModel.dart';
import 'package:projectb/porter/getquote.dart';
import 'package:projectb/porter/models/createOrderResponse.dart';
import 'package:projectb/porter/models/getQuoteModel.dart';
import 'package:projectb/porter/models/getQuoteResponse.dart';
import 'package:projectb/porter/trackOrder.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'package:projectb/porter/models/createOrderModel.dart' as orderModel;
import 'package:http/http.dart' as http;



class PorterUtils extends StatefulWidget {
  @override
  _PorterUtilsState createState() => _PorterUtilsState();
}

class _PorterUtilsState extends State<PorterUtils> {
  DropDetails? dropDetails;
  Customer? customer;
  String quoteFare = '';
  String orderid = '';
  List<Address> list = [];
  String? userID;
  Address? address;


  @override
  void initState() {
    super.initState();
    _initializeUser().then((_) {
      fetchAddressData().then((_) {
        getQuote(PickupDetails as PickupDetails, DropDetails as DropDetails,
            Customer as Customer).then((_) {
          createOrder();
        });
      });
    });
  }

  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;
    });
  }

  Future<void> fetchAddressData() async {

    if (userID == null) {
      print('User ID is null');
      return;
    }

    final String addressUrl = '${URLConstants.fetchAddress}?user_id=$userID';

    try {
      final response = await http.get(
        Uri.parse(addressUrl),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          print('response: ${response.body}');
          List<dynamic> addressJsonResponse = json.decode(response.body);

          // Assuming the JSON structure is an array with a single object
          if (addressJsonResponse.isNotEmpty) {
            var userData = addressJsonResponse[0]['user'][userID];
            if (userData != null) {
              Map<String, dynamic> addressData = userData['address'];

              if (addressData != null) {
                List<Address> fetchedAddress = [];

                // Iterate over the keys (a001, a002, etc.) in addressData
                addressData.forEach((key, value) {
                  // Assuming value is a Map<String, dynamic> for each key
                  if (value is Map<String, dynamic>) {
                    address = Address.fromJson(value);
                    address!.addressType =
                    value['addressType']; // Setting addressType
                    fetchedAddress.add(address!);
                  } else {
                    print('Unexpected data format: $value');
                  }
                });

                setState(() {
                  list = fetchedAddress;
                  print(fetchedAddress.map((e) => e.addressType).join(', '));
                });

                if (fetchedAddress.isNotEmpty) {
                  address = fetchedAddress.first;
                  print('lat:${address!.lat},lng:${address!.lng}');
                  dropDetails = DropDetails(
                    lat: double.parse(address!.lat),
                    lng: double.parse(address!.lng),
                  );
                  print('DropDetails: ${dropDetails.toString()}');

                  customer = Customer(
                    name: address!.name,
                    mobile: Mobile(
                      countryCode: '+91',
                      number: '${AppConstants.mobileNumber}', // Placeholder for mobile number
                    ),
                  );

                  print('Customer: $customer');
                } else {
                  print('Error: No address found for the user');
                }
              } else {
                print('Error: Address data not found in response');
              }
            } else {
              print('Error: User ID not found in response');
            }
          } else {
            print('Error: Empty response body');
          }
        } else {
          print('Error: Empty response body');
        }
      } else {
        print('Error fetching address data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught while fetching address data: $e');
    }
  }


  Future<String> getQuote(PickupDetails pickupDetails, DropDetails dropDetails,
      Customer customer) async {
    final quoteRequest = QuoteRequest(
      pickupDetails: pickupDetails,
      dropDetails: dropDetails,
      customer: customer,
    );

    print('Sending quote request: ${jsonEncode(quoteRequest.toJson())}');

    try {
      final response = await http.post(
        Uri.parse(URLConstants.porterApiGetQuoteUrl),
        headers: {
          'X-API-KEY': URLConstants.porterApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(quoteRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        GetQuoteResponse getQuoteResponse = GetQuoteResponse.fromJson(data);
        // Handle the parsed response
        print('Response: ${getQuoteResponse.toJson()}');
        setState(() {
          quoteFare =
              getQuoteResponse.vehicles.first.fare.minorAmount.toString();

        });
        print('fare:${getQuoteResponse.vehicles.first.fare.minorAmount.toString()}');
        return getQuoteResponse.vehicles.first.fare.minorAmount.toString();
      } else {
        // Handle error
        print('getquote error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return '0';
      }
    } catch (e) {
      print('Exception caught: $e');
      return '0';
    }
  }

  Future<String> createOrder() async {
    if (address == null || dropDetails == null || customer == null) {
      print('Address, dropDetails, or customer is null');
      return '';
    }

    final orderRequest = orderModel.CreateOrderRequest(
      requestId: 'TEST_0_8236098bfc-87e0-11ec-a8a3-0242ac120004',
      deliveryInstructions: orderModel.DeliveryInstructions(
        instructionsList: [
          orderModel.Instruction(type: 'text', description: 'handle with care'),
        ],
      ),
      pickupDetails: orderModel.PickupDetails(
        address: orderModel.Address(
          apartmentAddress: '27',
          streetAddress1: 'Sona Towers',
          streetAddress2: 'Krishna Nagar Industrial Area',
          landmark: 'Hosur Road',
          city: 'Bengaluru',
          state: 'Karnataka',
          pincode: '560029',
          country: 'India',
          lat: 12.935025018880504,
          lng: 77.6092605236106,
          contactDetails: orderModel.ContactDetails(
            name: 'Test Sender',
            phoneNumber: '+919876543210',
          ),
        ),
      ),
      dropDetails: orderModel.DropDetails(
        address: orderModel.Address(
          apartmentAddress: address!.addressType,
          streetAddress1: address!.addressLine1,
          streetAddress2: address!.addressLine2,
          landmark: '',
          city: 'chennai',
          state: 'tamilnadu',
          pincode: address!.pincode,
          country: 'India',
          lat: dropDetails!.lat,
          lng: dropDetails!.lng,
          contactDetails: orderModel.ContactDetails(
            name: customer!.name,
            phoneNumber: customer!.mobile.number,
          ),
        ),
      ),
      additionalComments: 'This is a test comment',
    );

    try {
      final response = await http.post(
        Uri.parse(URLConstants.porterApiCreateTaskUrl),
        headers: {
          'x-api-key': URLConstants.porterApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        CreateOrderResponse createOrderResponse = CreateOrderResponse.fromJson(
            data);
        // Handle the parsed response
        print('Response: ${createOrderResponse.toJson()}');
        setState(() {
          orderid = createOrderResponse.orderId.toString();
          print('fare:${createOrderResponse.orderId}');
        });

        return createOrderResponse.orderId;
      } else {
        // Handle error
        print('orderid error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return '0';
      }
    } catch (e) {
      print('Exception caught: $e');
      return '0';
    }
  }


  // Assuming this variable holds the orderId after creating an order

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Porter Utils'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await fetchAddressData();
                if (dropDetails != null && customer != null) {
                  final pickupDetails = PickupDetails(
                    lat: 12.935025018880504,
                    lng: 77.6092605236106,
                  );
                  orderid = await createOrder();
                  await getQuote(pickupDetails, dropDetails!, customer!);
                } else {
                  print('Drop details or customer details are missing');
                }
              },
              child: Text('Get Quote and Create Order'),
            ),
            if (quoteFare.isNotEmpty) Text('Fare: $quoteFare'),
            if (orderid.isNotEmpty) Text('Order ID: $orderid'),
          ],
        ),
      ),
    );
  }
}
//
// void main() => runApp(MaterialApp(home: PorterUtils()));