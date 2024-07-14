import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/trackOrderModel.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  final String apiKey = '63846e8c-cf19-4005-8ce6-18252901dd7d';
  final String baseUrl = 'https://pfe-apigw-uat.porter.in/v1';
  TrackOrderResponse? _response;
  bool _isLoading = false;

  Future<void> trackOrder(String orderId) async {
    setState(() {
      _isLoading = true;
    });

    final url = '$baseUrl/orders/$orderId';
    final headers = {
      'X-API-KEY': apiKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          print('Parsed JSON: $data');
          if (data != null && data is Map<String, dynamic>) {
            setState(() {
              _response = TrackOrderResponse.fromJson(data);
              _isLoading = false;
            });
          } else {
            print('Failed to parse response body.');
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          print('Response body is empty.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Failed to track order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _response == null
            ? ElevatedButton(
          onPressed: () async {
            final orderId = 'CRN1720093674858';
            await trackOrder(orderId);
          },
          child: Text('Track Order'),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order ID: ${_response!.orderId}'),
            Text('Status: ${_response!.status}'),
            if (_response!.partnerInfo != null) ...[
              Text('Partner Name: ${_response!.partnerInfo!.name}'),
              Text('Vehicle Number: ${_response!.partnerInfo!.vehicleNumber}'),
              Text('Vehicle Type: ${_response!.partnerInfo!.vehicleType}'),
              Text('Mobile: ${_response!.partnerInfo!.mobile.countryCode}-${_response!.partnerInfo!.mobile.mobileNumber}'),
              if (_response!.partnerInfo!.partnerSecondaryMobile != null)
                Text('Secondary Mobile: ${_response!.partnerInfo!.partnerSecondaryMobile!.countryCode}-${_response!.partnerInfo!.partnerSecondaryMobile!.mobileNumber}'),
              if (_response!.partnerInfo!.location != null)
                Text('Location: Lat ${_response!.partnerInfo!.location!.lat}, Long ${_response!.partnerInfo!.location!.long}'),
            ],
            Text('Pickup Time: ${DateTime.fromMillisecondsSinceEpoch(_response!.orderTimings.pickupTime * 1000)}'),
            if (_response!.orderTimings.orderAcceptedTime != null)
              Text('Order Accepted Time: ${DateTime.fromMillisecondsSinceEpoch(_response!.orderTimings.orderAcceptedTime! * 1000)}'),
            if (_response!.orderTimings.orderStartedTime != null)
              Text('Order Started Time: ${DateTime.fromMillisecondsSinceEpoch(_response!.orderTimings.orderStartedTime! * 1000)}'),
            if (_response!.orderTimings.orderEndedTime != null)
              Text('Order Ended Time: ${DateTime.fromMillisecondsSinceEpoch(_response!.orderTimings.orderEndedTime! * 1000)}'),
            if (_response!.fareDetails.estimatedFareDetails != null)
              Text('Estimated Fare: ${_response!.fareDetails.estimatedFareDetails!.currency} ${_response!.fareDetails.estimatedFareDetails!.minorAmount / 100}'),
            if (_response!.fareDetails.actualFareDetails != null)
              Text('Actual Fare: ${_response!.fareDetails.actualFareDetails!.currency} ${_response!.fareDetails.actualFareDetails!.minorAmount / 100}'),
          ],
        ),
      ),
    );
  }
}