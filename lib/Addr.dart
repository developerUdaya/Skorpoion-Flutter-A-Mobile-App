import 'package:flutter/material.dart';
import 'package:projectb/AddressPage.dart';
import 'package:projectb/Homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';

class Addr extends StatefulWidget {

  final String? googleAddress;
  final LatLng? latLng;
  final String? addressId;

  const Addr({Key? key, this.googleAddress, this.latLng, this.addressId}) : super(key: key);

  @override
  State<Addr> createState() => _AddrState();
}

class _AddrState extends State<Addr> {
  Color customGreenColor = Color(0xFF53b175);
  String selectedAddressType = "";
  bool showOtherTextField = false;
  TextEditingController personNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLine3Controller = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController otherAddressTypeController = TextEditingController();
  String? userID;


  @override
  void initState() {
    super.initState();
    _initializeUser();

    if (widget.addressId != null) {
      // Load address details using addressId
      //  _loadAddressDetails();
    }
  }
  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;
    });
  }



  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    personNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    addressLine3Controller.dispose();
    otherAddressTypeController.dispose();
    pincodeController.dispose();
    super.dispose();

  }

  Future<void> addAddress() async {
    // Prepare the address data
    print("widget.googleAddress: ${widget.googleAddress}");
    var addressData = {
      "user_id": userID,
      "address": {
        "addressType": selectedAddressType == "Other" ? otherAddressTypeController.text : selectedAddressType,
        "addressGoogleMap": widget.googleAddress ?? "",  // Ensure to handle empty case
        "name": personNameController.text,
        "addressLine1": addressLine1Controller.text,
        "addressLine2": addressLine2Controller.text,
        "addressLine3": addressLine3Controller.text,
        "pincode": pincodeController.text,
        "lat": "${widget.latLng?.latitude}",
        "lng": "${widget.latLng?.longitude}"// Update with actual latitude and longitude if needed
      }
    };
    // Print the data being sent to the API
    print("Sending data: $addressData");
    // Send the data to backend API
    var url = Uri.parse('${URLConstants.addAddress}');

    if (widget.addressId != null) {
      // If addressId is not null, update the address
      url = Uri.parse('${URLConstants.updateAddress}');
      addressData["address_id"] = widget.addressId;
    }


    var response;
    try {
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(addressData),
      );
    } catch (e) {
      print("Error sending request: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Network Error"),
          content: Text("Failed to connect to the server. Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    if (response.statusCode == 200) {
      // Address added successfully
      var responseData = jsonDecode(response.body);
      print("Response data: ${responseData["message"]}");
      print("Latitude: ${widget.latLng?.latitude}, Longitude: ${widget.latLng?.longitude}");
    } else {
      // Error adding address
      print("Error adding address: ${response.statusCode} ${response.body}");
      // Show an error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to add address. Please try again later."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Future<void> _loadAddressDetails() async {
  //   // Fetch address details from backend using widget.addressId
  //   // var url = Uri.parse('${URLConstants.getAddressDetails}/${widget.addressId}');
  //   try {
  //     var response = await http.get(url, headers: {"Content-Type": "application/json"});
  //     if (response.statusCode == 200) {
  //       var address = jsonDecode(response.body);
  //       setState(() {
  //         personNameController.text = address['name'];
  //         addressLine1Controller.text = address['addressLine1'];
  //         addressLine2Controller.text = address['addressLine2'];
  //         addressLine3Controller.text = address['addressLine3'];
  //         pincodeController.text = address['pincode'];
  //         selectedAddressType = address['addressType'];
  //         showOtherTextField = selectedAddressType == "Other";
  //         if (showOtherTextField) {
  //           otherAddressTypeController.text = address['addressType'];
  //         }
  //       });
  //     } else {
  //       print("Failed to load address details: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error fetching address details: $e");
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 17,
            color: Colors.black,
            onPressed: () {
            },
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'My Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: userID != null && userID!.isNotEmpty? SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Person Name',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: personNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'House/Flat/Floor No.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: addressLine1Controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your house/flat/floor number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Apartment/Road/Street',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: addressLine2Controller,
                  decoration: InputDecoration(
                    hintText: 'Enter apartment/road/street name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Landmark',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: addressLine3Controller,
                  decoration: InputDecoration(
                    hintText: 'Enter nearby landmark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Pincode',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: pincodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter your pincode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Address Type',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildAddressTypeButton("Home"),
                    SizedBox(width: 10),
                    _buildAddressTypeButton("Work"),
                    SizedBox(width: 10),
                    _buildAddressTypeButton("Other"),
                  ],
                ),
                if (showOtherTextField)
                  Column(
                    children: [
                      SizedBox(height: 15),
                      TextField(
                        controller: otherAddressTypeController,
                        decoration: InputDecoration(
                          hintText: 'Enter Address Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: MaterialButton(
                        onPressed: () {
                          addAddress();
                        },
                        color: customGreenColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ): Center(child: CircularProgressIndicator(),),
      ),
    );
  }
  Widget _buildAddressTypeButton(String type) {
    bool isSelected = selectedAddressType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressType = type;
          showOtherTextField = type == "Other";
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}