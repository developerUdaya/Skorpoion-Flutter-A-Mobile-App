import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projectb/Account.dart';
import 'package:projectb/Addr.dart';
import 'package:projectb/AddressPage.dart';
import 'package:projectb/DescriptionPage.dart';
import 'package:projectb/Errorpage.dart';
import 'package:projectb/Explore.dart';
import 'package:projectb/FavouritePage.dart';
import 'package:projectb/Filters.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/LoginWithPhoneNumber.dart';
import 'package:projectb/MapPage.dart';

import 'package:projectb/UserDetail.dart';
import 'package:projectb/Onboarding.dart';
import 'package:projectb/OrderAccepted.dart';
import 'package:projectb/OrderHistoryPage.dart';
import 'package:projectb/OtpPage.dart';
import 'package:projectb/Search.dart';
import 'package:projectb/SelectLocation.dart';
import 'package:projectb/Signin.dart';
import 'package:projectb/apiTest.dart';
import 'package:projectb/apiTest2.dart';
import 'package:projectb/couponPage.dart';
import 'package:projectb/porter/createOrder.dart';
import 'package:projectb/porter/getquote.dart';

import 'AddCart.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MaterialApp(
          home: Signin())
  );

}



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Image.network("https://static.vecteezy.com/system/resources/thumbnails/019/607/567/small/fast-food-vector-clipart-design-graphic-clipart-design-free-png.png")
      ),
      backgroundColor: Colors.white,
    );

  }
}