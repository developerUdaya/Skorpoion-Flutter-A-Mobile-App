import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'models/productsModel.dart';
import 'dart:convert';

class DescriptionPage extends StatefulWidget {

  final Product1 product;
  int quantity;

  DescriptionPage({Key? key, required this.product, required this.quantity}) : super(key: key);

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  Color? _removeButtonColor;
  Color? _addButtonColor;

  double productsPrice=0;

  int _quantity = 0;

  bool _isFavorite = false;

  Color customGreenColor = Color(0xFF53b175);

  String? userID;

  Repository repository = Repository();
  @override
  void initState() {
    super.initState();
    _removeButtonColor = null;
    _addButtonColor = null;

    setState(() {
      _quantity = widget.quantity;
    });

    fetchFavoriteStatus();

    _initializeUser();
  }

  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }



  Future<void> fetchFavoriteStatus() async {
    bool isFavorite = await repository.fetchFavoriteStatus(widget.product.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }



  Future<void> increaseQuantity() async {
    await repository.increaseCartQuantity(widget.product.id);
    setState(() {
      _quantity++;
    });
  }

  Future<void> decreaseQuantity() async {
    if (_quantity > 0) {
      await repository.decreaseCartQuantity(widget.product.id);
      setState(() {
        _quantity--;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Handle back button press
      // For example, navigate to homepage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(), // Replace with the desired destination
        ),
      );
      // Return false to prevent default behavior
      return false;
    },
    child:Scaffold(
      body: userID != null && userID!.isNotEmpty? SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 22, // Adjust the size as needed
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18), // Add padding to the right
                  child: IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: Colors.black,
                      size: 22, // Adjust the size as needed
                    ),
                    onPressed: () {
                      // Add send button functionality
                    },
                  ),
                )
              ],
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.grey[300]!],
                  stops: [0, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              width: double.infinity,
              height: 300, // Adjust the height as needed
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  widget.product.imageUrl, // Replace with your image URL
                  fit: BoxFit.contain,
                ),
              ),
            ),




            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        80, // Adjust width as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         widget.product.productName,

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '1kg, Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset:
                  Offset(5, -6), // Adjust the vertical offset as needed
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey.shade600,
                    ),

                    onPressed: () async {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      if  (_isFavorite)  {
                        await repository.addToFavorites(widget.product.id);
                      } else {
                        await repository.removeFromFavorites(widget.product.id);
                      }
                    },
                    color: Colors.grey.shade600, // Adjust the color here
                    iconSize: 27, // Adjust the size here
                  ),
                ),
              ],
            ),


            SizedBox(height: 22),
            Padding(padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 27),
                  color: _removeButtonColor ?? Colors.grey.shade500,

                  onPressed: () async{
                    if(_quantity==0){
                      return;
                    }

                    setState(() {
                      _removeButtonColor = Colors.green;
                    });
                    // Add remove button functionality
                    await decreaseQuantity();
                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        _removeButtonColor = null;
                      });
                    });
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  width: 47,
                  height: 47,
                  child: Center(
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 27),
                  color: _addButtonColor ?? Colors.grey.shade600,
                  onPressed: () async {
                    setState(() {
                      // _quantity = (_quantity + 1).clamp(0, 99);
                      _addButtonColor = Colors.green;
                    });
                    // Add add button functionality
                    await increaseQuantity();
                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        _addButtonColor = null;
                      });
                    });
                  },
                ),
                SizedBox(width: 120), // Adjust the width as needed
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                   '₹${widget.product.productPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
                ),



            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Container(
                width: 350,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 0.7),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 7), // Add space between the title and description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        widget.product.productDescription,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),







            SizedBox(height: 25),
            Container(
              width: 300,
              height: 60,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigation(page: 2,),
                    ),
                  );
                },
                color: customGreenColor, // Use the custom color
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                ),
                child: Text("Add To Basket",
                  style: TextStyle(
                    fontSize: 17,
                  ),),
              ),
            ),




          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
    ),
    );
  }
}
