import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectb/OtpPage.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  @override
  _LoginWithPhoneNumberState createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyPhoneNumber() async {
    String phoneNumber = _phoneNumberController.text.trim();
    String completePhoneNumber = '+91$phoneNumber'; // Forming complete phone number

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: completePhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Navigate to next screen upon successful verification if needed
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          // Handle verification failure (e.g., show error message)
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                verificationId: verificationId,
                phoneNumber: phoneNumber, // Pass original phone number without country code
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto-retrieval timeout
        },
      );
    } catch (e) {
      print('Error verifying phone number: $e');
      // Handle other errors (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _verifyPhoneNumber,
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
            SizedBox(height: 10),
            Text(
              'Enter Your Mobile Number',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              maxLength: 10, // Assuming you only want 10-digit numbers without +91
              maxLines: 1,
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your mobile number',
                prefixIcon: Icon(Icons.phone),
                prefixStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
                counterText: '',
              ),
              onChanged: (value) {
                // Limit to 10 digits, remove country code
                if (value.length > 10) {
                  _phoneNumberController.text = value.substring(0, 10);
                  _phoneNumberController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _phoneNumberController.text.length),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
