import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectb/urlConstant/AppConstants.dart';

import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Testpages()
  );
}

class Testpages extends StatefulWidget {
  const Testpages({super.key});

  @override
  State<Testpages> createState() => _TestpagesState();
}

class _TestpagesState extends State<Testpages> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MaterialButton(
            onPressed: (){
              print("AppConstants.getPhoneNumber()");
              print(AppConstants.getPhoneNumber());
            },
            child: Text("Click"),
          ),
        ),
      ),
    );
  }
}
