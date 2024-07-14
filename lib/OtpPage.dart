import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectb/LoginWithPhoneNumber.dart';
import 'package:projectb/SelectLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projectb/urlConstant/UrlConstant.dart';





class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpPage({Key? key, required this.verificationId, required this.phoneNumber}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOtp() async {
    String smsCode = _otpController.text.trim();

    if (smsCode.length != 6) {
      // Show an error if the code is not 6 digits
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a 6-digit OTP")),
      );
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);

      // After successful OTP verification, send phone number to backend
      await _addPhoneNumberToDB(widget.phoneNumber);

      // Navigate to the desired page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectLocation(verificationId: '',)),
      );
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP, please try again")),
      );
    }
  }

  Future<void> _addPhoneNumberToDB(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${URLConstants.addUserPhoneNumber}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': phoneNumber}), // Sending phone number as 'user_id'
      );

      if (response.statusCode == 200) {
        // Successfully added phone number
        print('Phone number added successfully');
      } else {
        // Handle error case
        print('Failed to add phone number: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error adding phone number to server: $e');
      // Handle other exceptions
    }
  }

  void _resendCode() {
    // Handle resending code (this should be implemented in your LoginWithPhoneNumber page)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginWithPhoneNumber(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginWithPhoneNumber(),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _verifyOtp, // Verify OTP on button press
          backgroundColor: Colors.green,
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                'Enter Your 6-digit Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Code',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _otpController,
                maxLength: 6,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '- - - - - -',
                  prefixStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _resendCode, // Handle resend code
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
