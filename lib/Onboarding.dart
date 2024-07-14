
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectb/Signin.dart';
import 'package:projectb/main.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});


  @override
  Widget build(BuildContext context) {

    Color customGreenColor = Color(0xFF53b175);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image

        Positioned.fill(child:  Image.asset('assets/Onboarding.png',
          fit: BoxFit.fill,
        ),
        ),


          // Content
          Column(
             mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height: 460 ,
              width: 10,),
              SizedBox(
                height: 70,
                width: 45,
                child:    Image.asset('assets/Carrot.png'),
              ),

               Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),


                Text(
                      "to our store",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),



              Text(
                "Get your food in as fast as one hour",
                style: TextStyle(
                  fontSize: 15,

                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40,),

              SizedBox( width: 330,
                height: 60,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signin(),
                      ),
                    );
                  },
                  color: customGreenColor, // Use the custom color
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                  ),
                  child: Text("Get Started",
                    style: TextStyle(
                      fontSize: 17,
                    ),),
                ),
              ),
              // SizedBox(height: 20.0),
              // Expanded(
              //   flex: 1,
              //   child: Container(), // Spacer
              // ),
            ],
          ),
        ],
      ),
    );
  }
}



