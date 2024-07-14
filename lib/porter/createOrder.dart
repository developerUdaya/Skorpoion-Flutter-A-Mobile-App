import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectb/porter/trackOrder.dart';


import 'models/createOrderModel.dart' as orderModel;
import 'models/createOrderResponse.dart';


class CreateOrderApi extends StatelessWidget {
  final String apiKey = '63846e8c-cf19-4005-8ce6-18252901dd7d';
  final String createOrderUrl = 'https://pfe-apigw-uat.porter.in/v1/orders/create';

  Future<void> createOrder(BuildContext context) async {
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
          apartmentAddress: 'this is apartment address',
          streetAddress1: 'BTM Layout',
          streetAddress2: 'This is My Order ID',
          landmark: 'BTM Layout',
          city: 'Bengaluru',
          state: 'Karnataka',
          pincode: '560029',
          country: 'India',
          lat: 12.947146336879577,
          lng: 77.62102993895199,
          contactDetails: orderModel.ContactDetails(
            name: 'Test Receiver',
            phoneNumber: '+919876543210',
          ),
        ),
      ),
      additionalComments: 'This is a test comment',
    );

    try {
      final response = await http.post(
        Uri.parse(createOrderUrl),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final createOrderResponse = CreateOrderResponse.fromJson(data);
        // Handle the parsed response
        print('Response: ${createOrderResponse.toJson()}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrackOrder()),
        );
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order API'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>  createOrder(context),
          child: Text('Create Order'),
        ),
      ),
    );
  }
}