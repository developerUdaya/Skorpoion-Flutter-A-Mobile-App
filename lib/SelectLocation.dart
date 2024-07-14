import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/OtpPage.dart';

class SelectLocation extends StatefulWidget {
  final String verificationId;

  const SelectLocation({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    Color customGreenColor = Color(0xFF53b175);
    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {

            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30),
              SizedBox(
                height: 170,
                child: Image.asset('assets/illustration.png'),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Text(
                      'Select Your Location',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Switch on your location to stay in tune with what's happening in your area",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 90),
                    Text(
                      "Your Zone",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Type your zone',
                        prefixStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Your Area",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Type your area',
                        prefixStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 330,
                      height: 60,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigation(page: 0),
                            ),
                          );
                        },
                        color: customGreenColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}