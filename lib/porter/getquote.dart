import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'models/getQuoteModel.dart';
import 'models/getQuoteResponse.dart';
import 'package:projectb/models/addressModel.dart';

class GetquoteApi extends StatefulWidget {
  @override
  _GetquoteApiState createState() => _GetquoteApiState();
}

class _GetquoteApiState extends State<GetquoteApi> {

  List<Address> list = [];
  String ? userID;

  @override
  void initState() {
    super.initState();
    fetchAddressData();
    getQuote();
    // _initializeUser();
  }

  // Future<void> _initializeUser() async {
  //   String? userId = await AppConstants.getPhoneNumber();
  //   setState(() {
  //     userID = userId;
  //
  //   });
  //  }


  final String apiKey = '63846e8c-cf19-4005-8ce6-18252901dd7d';
  final String quoteUrl = 'https://pfe-apigw-uat.porter.in/v1/get_quote';

  PickupDetails pickupDetails = PickupDetails(lat: 12.935025018880504, lng: 77.6092605236106);

  DropDetails? dropDetails;
  Customer? customer;



  Future<void> fetchAddressData() async {
    const userID = 9003205532;
    final String addressUrl = '${URLConstants.fetchAddress}?user_id=$userID';

    try {
      final response = await http.get(
        Uri.parse(addressUrl),
      );

      if (response.statusCode == 200) {
        print('response: ${response.body}');
        List<dynamic> addressJsonResponse = json.decode(response.body);

        List<Address> fetchedAddress = [];
        for (var entry in addressJsonResponse) {

          Map<String, dynamic> userMap = entry['user'];
          if (userMap != null && userMap.containsKey(userID.toString())) {
            Map<String, dynamic> addressData = entry['user'][userID.toString()];

            if (addressData != null) {
              Map<String, dynamic> addressMap = addressData['address'];

              for (var addEntry in addressMap.entries) {
                String type = addEntry.key;
                Map<String, dynamic> typeData = addEntry.value;


                for (var addressEntry in typeData.entries) {
                  Map<String, dynamic> data = addressEntry.value;
                  Address address = Address.fromJson(data);

                  print(address.toString());

                  address.addressType = type;
                  fetchedAddress.add(address);
                }
              }
            } else {
              print('Error: User ID not found in response');
            }
          }
        }

        setState(() {
          list = fetchedAddress;
          print(fetchedAddress.map((e) => e.addressType,).join(', '));
          print("fetchedAddress.map((e) => e.addressType).join(', ')");

        });

        if (fetchedAddress.isNotEmpty) {
          Address address = fetchedAddress.first;

          print('lat:${address.lat},lng:${address.lng}');
          dropDetails = DropDetails(
            lat: double.parse(address.lat),
            lng: double.parse(address.lng),
          );
          print('DropDetails: ${dropDetails.toString()}');

          customer = Customer(
            name: address.name,
            mobile: Mobile(
              countryCode: '+91', number: '${AppConstants.getPhoneNumber()}',
            ),
          );


          print('Customer: $customer');

        } else {
          print('Error: No address found for the user');
        }
      } else {
        print('Error fetching address data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught while fetching address data: $e');
    }
  }

  Future<void> getQuote() async {
    if (dropDetails!=null && customer != null) {
      final quoteRequest = QuoteRequest(
        pickupDetails: pickupDetails,
        dropDetails: dropDetails!,
        customer: customer!,
      );

      print('Sending quote request: ${jsonEncode(quoteRequest.toJson())}');

      try {
        final response = await http.post(
          Uri.parse(quoteUrl),
          headers: {
            'X-API-KEY': apiKey,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(quoteRequest.toJson()),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print(data);
          final getQuoteResponse = GetQuoteResponse.fromJson(data);
          // Handle the parsed response
          print('Response: ${getQuoteResponse.toJson()}');
        } else {
          // Handle error
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Exception caught: $e');
      }
    } else {
      print('failed quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Quote API'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: getQuote,
          child: Text('Get quote'),
        ),
      ),
    );
  }
}