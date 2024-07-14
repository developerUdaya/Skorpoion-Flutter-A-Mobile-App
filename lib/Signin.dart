import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectb/LoginWithPhoneNumber.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  Color customGreenColor = Color(0xFF4a67ad);
  Color customGreenColor1 = Color(0xFF5384ed);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // Close the app
        SystemNavigator.pop();
        // Return true to prevent default behavior
        return true;
      },
      child:Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image and Text
              Container(
                height: MediaQuery.of(context).size.height * 0.5,

                // Adjust height as needed
                decoration:

                const BoxDecoration(

                  image: DecorationImage(

                    image: AssetImage("assets/Signin1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 9),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Get your Orders ',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 30),
              // Phone Number Textfield
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                // Button
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWithPhoneNumber(),
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  label: Text(
                    'Login with Phone number',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),

                ),
              ),
              SizedBox(height: 30),
              // "Or Connect With" Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'or connect with',

                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),

                  textAlign: TextAlign.center,
                ),

              ),
              SizedBox(height: 30),
              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: 300,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, '/second');
                    },
                    icon: Image.asset(('assets/ggooggle.png'),
                      width:232,
                      height: 72,

                    ),
                    backgroundColor: customGreenColor1,
                    label: Text(
                      '',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),


                  ),
                ),
              ),


              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: 300,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // Handle sign in with Facebook
                    },
                    icon: Image.asset(('assets/fbroup.png'),
                      width:232,
                      height: 72,

                    ),
                    backgroundColor: customGreenColor,
                    label: Text('',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),

                  ),
                ),
              ),






            ]

        ),
      ),
    );


  }
}