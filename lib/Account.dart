import 'package:flutter/material.dart';
import 'package:projectb/Addr.dart';
import 'package:projectb/AddressPage.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/UserDetail.dart';
import 'package:projectb/OrderHistoryPage.dart';
import 'package:projectb/Signin.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Color customGreenColor = Color(0xFF53b175);
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
      // Handle back button press
      // For example, navigate to homepage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigation(page: 0,), // Replace with the desired destination
        ),
      );
      // Return false to prevent default behavior
      return false;
    },
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),

        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 200,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 33, bottom: 8), // Adjust top and left padding for the image
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(''),
                ),
              ),
              SizedBox(width: 16), // Add some space between the avatar and text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,width: 19,),
                  Text(
                    'Name name', // Name text
                    style: TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4), // Add some space between the name and email
                  Row(
                    children: [
                      Text(
                        'abc.abc@gmail.com', // Email text
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right:17,top: 4, bottom: 4),
                // Adjust top and right padding for the icon
                child: SizedBox(
                  width: 0.2,

                  child: IconButton(
                    icon: Icon(Icons.edit_outlined),
                    color: Colors.green,
                    onPressed: () {
                      // Add edit functionality here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
        child: Column(
          children: [
            // Row(
            //   children: [

            SizedBox(
                height: 20),



            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/ordersicon.png'),


                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Orders',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 222,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal:10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),
            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Userdetail(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/vector.png'),


                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'My Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 192,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),


            SizedBox(width: 30,
                height: 4),
            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/deliceryaddress.png'),


                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 142.5,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),
            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/vectoricon.png'),


                    ),

                    const Padding(
                      padding: EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 130,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),
            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/promoicon.png'),


                    ),

                    const Padding(
                      padding: EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Promo code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 176,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),
            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/bellicon.png'),

                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Notification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                   SizedBox(width: 184.5,),
                      Icon(Icons.arrow_forward_ios,   color: Colors.black,
                        size: 18,),


                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),



            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/helpicon.png'),


                    ),

                    const Padding(
                      padding: EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'Help',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 240,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(width: 30,
                height: 4),



            SizedBox(
              child: MaterialButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),

                      child: Image.asset('assets/abouticon.png'),


                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:8,top: 8, bottom: 8),
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 230,),
                    Icon(Icons.arrow_forward_ios,   color: Colors.black,
                      size: 18,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),


            SizedBox(height: 40,),
            SizedBox(
              width: 300,
              child: FloatingActionButton.extended(
                onPressed: () {
                  AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('close'),
                      ),
                    ],
                    title: Text('LOGOUT'),
                    content: Text('Are you want to logout from the application?'),

                  );
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 2,left: 30),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white, // Change the color here
                      BlendMode.srcIn,
                    ),
                    child:Image.asset('assets/log.png'
                    ),

                  ),
                ),
                backgroundColor: customGreenColor,
                label: Padding(
                  padding: const EdgeInsets.only(right: 120,left:80 ),
                  child: Text(
                    'LogOut',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),


              ),
            ),

          ],
        ),
        ),
      ),
    ),
    );
  }
}