import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String phoneNumberKey = 'phoneNumber';
  static String? mobileNumber;

  static String? getMobileNumberFromFirebase() {
    final user = _auth.currentUser;
    if (user != null && user.phoneNumber != null) {
      mobileNumber = user.phoneNumber!.substring(3); // Skip the country code
      return mobileNumber;
    }
    return null;
  }

  static Future<void> savePhoneNumber(String? phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(phoneNumberKey, phoneNumber ?? '');
  }

  static Future<String?> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPhoneNumber = prefs.getString(phoneNumberKey);
    if (storedPhoneNumber != null && storedPhoneNumber.isNotEmpty) {

      return storedPhoneNumber;
    } else {
      String? firebasePhoneNumber = getMobileNumberFromFirebase();
      if (firebasePhoneNumber != null) {
        await savePhoneNumber(firebasePhoneNumber);
      }

      print(firebasePhoneNumber);
      return firebasePhoneNumber;
    }
  }
}
