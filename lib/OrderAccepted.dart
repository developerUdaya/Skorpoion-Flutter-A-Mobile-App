import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';


class OrderAcceptedPage extends StatefulWidget {
  const OrderAcceptedPage({Key? key}) : super(key: key);

  @override
  State<OrderAcceptedPage> createState() => _OrderAcceptedPageState();
}

class _OrderAcceptedPageState extends State<OrderAcceptedPage> {

  Color customGreenColor = Color(0xFF53b175);
  Color customGreenColor1 = Color(0xFF489e67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/sucess3.gif',
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
            ),

            Text(
              'Your Order has been',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),

            Text(
              'accepted',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10),
            Text(
              "Your items has been placed and is on",
              style: TextStyle(

                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),

            Text(
              "it's way to being processed",
              style: TextStyle(

                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),

            SizedBox(height: 110),
            SizedBox(
              width: 284,
              height: 50,
              child: MaterialButton(
                onPressed: () {},
                color: customGreenColor,
                textColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  "Track Order",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

        GestureDetector(
          onTap: () {
            // Navigate to another page here
            // For example:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(page:0),
              ),
            );
          },
          child:
            Text(
              "Back to home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
        ),],
        ),
      ),
    );
  }

}
