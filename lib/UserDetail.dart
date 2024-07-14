import 'package:flutter/material.dart';
import 'package:projectb/Account.dart';
import 'package:projectb/Homepage.dart';

class Userdetail extends StatefulWidget {
  const Userdetail({super.key});

  @override
  State<Userdetail> createState() => _UserdetailState();
}

class _UserdetailState extends State<Userdetail> {
  @override
  Widget build(BuildContext context) {
    Color customGreenColor = Color(0xFF53b175);
    return WillPopScope(
        onWillPop: () async {
      // Handle back button press
      // For example, navigate to homepage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigation(page: 4,), // Replace with the desired destination
        ),
      );
      // Return false to prevent default behavior
      return false;
    },
    child:Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 17,
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(page: 4,),
              ),
            );
          },
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'My Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),

    body: Container(
    child: Column(
    children: [
    Row(
       children: [

    Padding(
    padding: const EdgeInsets.only(top:18,left: 15,right: 265),
    child: Text(
    'Name',
    style: TextStyle(
    // fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black,
    ),
    ),
    ),

    ],
    ),


      Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Your Name', // Set the hint text to "Name"
            hintStyle: TextStyle(fontSize: 14, color: Colors.black45), // Hint text style
          ),
        ),
      ),




    SizedBox(width: 30),

      Row(
        children: [

          Padding(
            padding: const EdgeInsets.only(top:18,left: 15,right: 280),
            child: Text(
              'Mail',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),

        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Your Email', // Set the hint text to "Name"
            hintStyle: TextStyle(fontSize: 14, color: Colors.black45), // Hint text style
          ),
        ),
      ),


      SizedBox(width: 30,),
      Row(
        children: [

          Padding(
            padding: const EdgeInsets.only(top:18,left: 15,right: 212),
            child: Text(
              'Date of Birth',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),

        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Your Date of Birth', // Set the hint text to "Name"
            hintStyle: TextStyle(fontSize: 14, color: Colors.black45), // Hint text style
          ),
        ),
      ),

      SizedBox(width: 30,),
      Row(
        children: [

          Padding(
            padding: const EdgeInsets.only(top:18,left: 15,right: 255),
            child: Text(
              'Gender',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),

        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter Your Gender', // Set the hint text to "Name"
            hintStyle: TextStyle(fontSize: 14, color: Colors.black45), // Hint text style
          ),
        ),
      ),


      SizedBox(height: 40),
      Container(
        width: 300,
        height: 60,
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(page: 4,),
              ),
            );
          },
          color: customGreenColor, // Use the custom color
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
          ),
          child: Text("Save",
            style: TextStyle(
              fontSize: 17,
            ),),
        ),
      ),
    ],

    ),

    ),



    ),
    );
  }
}
