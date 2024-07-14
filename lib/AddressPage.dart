import 'package:flutter/material.dart';
import 'package:projectb/Account.dart';
import 'package:projectb/Addr.dart';
import 'package:projectb/MapPage.dart';
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'dart:convert';
import 'models/addressModel.dart';
import 'package:http/http.dart' as http;

class AddressPage extends StatefulWidget {

  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  Color customGreenColor = Color(0xFF53b175);


  List<Address> addressList = [];

  String? userID;

  @override
  void initState() {
    super.initState();
    loadAddress();
    _initializeUser();
  }

  Future<void> loadAddress() async{

    Repository repository =Repository();
    List<Address> addresses = await repository.loadAddresses();
    setState(() {
      addressList = addresses;
    });
  }
  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }


  Future<void> updateAddress(String addressId) async {
    // Find the address with the given addressId in addressList
    Address? selectedAddress;
    for (var address in addressList) {
      if (address.isChecked) {
        selectedAddress = address;
        break;
      }
    }

    if (selectedAddress != null && selectedAddress.addressId != addressId) {
      selectedAddress.isChecked = false; // Uncheck previously selected address
    }

    // Find the address to check
    for (var address in addressList) {
      if (address.addressId == addressId) {
        address.isChecked = true; // Check the selected address
      }
    }

    // Update the UI
    setState(() {});

    // Prepare the request payload
    final payload = jsonEncode({
      'user_id': userID,
      'address_id': addressId,
      'address': {
        'isChecked': true.toString(), // Convert to string if necessary
      },
    });

    // Debug log the payload
    print('Request payload: $payload');

    // Update the isChecked status in the database via API call
    try {
      final response = await http.post(
        Uri.parse('${URLConstants.updateAddress}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: payload,
      );

      // Debug log the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Address updated successfully');
        // Optionally fetch addresses again to refresh from server
        await loadAddress();
      } else {
        print('Failed to update address: ${response.reasonPhrase}');
        // Handle error scenario
      }
    } catch (e) {
      print('Error updating address: $e');
      // Handle network or other errors
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // For example, navigate to homepage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Addr(), // Replace with the desired destination
          ),
        );
        // Return false to prevent default behavior
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 17,
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addr(),
                ),
              );
            },
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,

        ),
        body: userID != null && userID!.isNotEmpty? Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1,
                      thickness: 0.7,
                      color: Colors.grey[300],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: addressList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Address address = addressList[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${address.addressType}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          updateAddress(address.addressId);
                                          // Uncheck all addresses
                                          for (var addr in addressList) {
                                            addr.isChecked = false;
                                          }
                                          // Check the selected address
                                          address.isChecked = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: address.isChecked ? Colors.green : Colors.transparent,
                                          border: Border.all(
                                            color: address.isChecked ? Colors.green : Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        child: address.isChecked
                                            ? Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                            : null,
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${address.addressLine1}, ${address.addressLine2}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    '${address.pincode}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    width: 75,
                                    height: 32,
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MapPage(
                                              addressId: address.addressId,
                                            ),
                                          ),
                                        );
                                      },
                                      color: customGreenColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Divider(
                                height: 1,
                                thickness: 0.7,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(), // Navigate to the Addr page to add a new address
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center( // Center the content
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Make the row as compact as its children
                            children: [
                              Icon(Icons.add, color: customGreenColor, size: 19),
                              SizedBox(width: 8),
                              Text(
                                'Add New Address',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold, // Make the font bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 20), // Adjust the padding value as needed
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Account(),
                        ),
                      );
                    },
                    color: customGreenColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}