

import 'package:flutter/material.dart';

class Errorpage extends StatefulWidget {
  const Errorpage({super.key});

  @override
  State<Errorpage> createState() => _ErrorpageState();
}

class _ErrorpageState extends State<Errorpage> {
  Color customGreenColor = Color(0xFF53b175);
   // Color customGreenColor1 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // contentPadding: EdgeInsets.zero
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23.0),
      ),
      backgroundColor: Colors.white,
      child: SizedBox(
        height: 520,
        width: 370,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top:10,left: 10,),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 24,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),

              ],
            ),



               SizedBox(
                 width: 200,
                height: 170,
               child: Image.asset(
                   'assets/burger and fries.png')
              ),

            Padding(padding: EdgeInsets.only(top: 40),
           child: Text(
              'Oops! Order Failed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 48,),
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              children: [

                SizedBox(
                  width: 270,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ten');
                    },
                    backgroundColor: customGreenColor,
                    label: Text(
                      'Please Try Again',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the next page when the image is tapped
                    Navigator.pushNamed(context, '/five');
                  },
                 child:Padding(
                   padding: const EdgeInsets.only(top:22,),

                   child: Text(
                       'Back to home',
                       style: TextStyle(
                         fontSize: 18.0,
                         color: Colors.black87,
                       ),
                     ),
    ),



                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}