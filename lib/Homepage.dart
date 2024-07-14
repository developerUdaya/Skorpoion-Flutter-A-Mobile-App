import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectb/Account.dart';
import 'package:projectb/AddCart.dart';
import 'package:projectb/DescriptionPage.dart';
import 'package:projectb/Explore.dart';
import 'package:projectb/FavouritePage.dart';
import 'package:projectb/Search.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/models/cartItem.dart';
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';

import 'models/productsModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Color? _removeButtonColor;
  Color? _addButtonColor;

  Color customGreenColor = Color(0xFF53b175);
  List<Product1> productsList =[];
  Map<String, int> productQuantities = {};
  int _selectedProductIndex = -1;

  String? userID;

  Repository repository = Repository();
  @override
  void initState() {
    super.initState();
    _removeButtonColor = null;
    _addButtonColor = null;


    _initializeUser();

    loadProducts();

  }

  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }


  Future<void> loadProducts() async{

    List<Product1> products = await repository.loadProducts();
    setState(() {


      productsList = products;
    });

    await fetchCartItems();
  }

  Future<void> fetchCartItems() async {

    List<CartItem> cartItems = await repository.loadCartItems();
    setState(() {
      for (CartItem item in cartItems) {
        productQuantities[item.id] = item.productCartQuantity;
      }
    });
  }

  Future<void> increaseCartQuantity(String productId) async {
    await repository.increaseCartQuantity(productId);
    setState(() {
      productQuantities[productId] = (productQuantities[productId] ?? 0) + 1;
    });
  }

  Future<void> decreaseCartQuantity(String productId) async {
    await repository.decreaseCartQuantity(productId);
    setState(() {
      if (productQuantities[productId] != null) {
        productQuantities[productId] = productQuantities[productId]! - 1;
        if (productQuantities[productId]! < 1) {
          productQuantities.remove(productId);
        }
      }
    });
  }



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
      child: Scaffold(
        body: userID != null && userID!.isNotEmpty?  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 45,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 8,
                      height: 15,),
                    Text(
                      'Chennai, Maduravoyal',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(5), // Adjust padding here
                child: SizedBox(
                  height: 43,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 15),
                      hintStyle: TextStyle(fontSize: 13),
                      hintText: 'Search Store',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    readOnly: true,
                    onTap: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=> Search()),

                      );
                    }
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 95,
                      child: Image.asset(
                        'assets/banner.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exclusive Offer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next page when the image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(page: 1),
                          ),
                        );

                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productsList[index];
                    final productId = product.id;
                    final quantity = productQuantities[productId] ?? 0;



                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DescriptionPage(product: productsList[index],quantity: quantity,),
                                    ),
                                  );// Replace '/nextPage' with the route name of the next page
                                },

                                child: SizedBox(
                                  height: 110,
                                  width: double.infinity,
                                  child: Image.network(
                                    productsList[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productsList[index].productName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),


                                  Text(
                                    '1kg, pricegm',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        '₹${productsList[index].productPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                 productQuantities[productsList[index].id]!=null
                                          ? Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 20),
                                            color: _removeButtonColor ?? Colors.grey.shade500,
                                            onPressed: () async {
                                              if (quantity > 0) {
                                                setState(() {
                                                  _removeButtonColor = Colors.green;
                                                });
                                                await decreaseCartQuantity(productId);
                                                // Wait for the quantity to update in the backend
                                                await Future.delayed(Duration(milliseconds: 500));
                                                await fetchCartItems();
                                                setState(() {
                                                  if (productQuantities[productId]! <= 0) {
                                                    _selectedProductIndex = -1;
                                                  }
                                                  _removeButtonColor = null;
                                                });
                                              }
                                            },
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            width: 37,
                                            height: 37,
                                            child: Center(
                                              child: Text(
                                                '$quantity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 20),
                                            color: _addButtonColor ?? Colors.grey.shade600,
                                            onPressed: () async {
                                              setState(() {
                                                _addButtonColor = Colors.green;
                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                              setState(() {
                                                _addButtonColor = null;
                                              });
                                            },
                                          ),
                                        ],
                                      )

                                          : SizedBox(
                                        width: 37,
                                        height: 37,
                                        child: Material(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(14),
                                          child: InkWell(
                                            onTap: () async {
                                              setState(()  {
                                                _selectedProductIndex = index;

                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best Selling',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next page when the image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(page: 1),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productsList[index];
                    final productId = product.id;
                    final quantity = productQuantities[productId] ?? 0;



                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DescriptionPage(product: productsList[index],quantity: quantity,),
                                    ),
                                  );// Replace '/nextPage' with the route name of the next page
                                },

                                child: SizedBox(
                                  height: 110,
                                  width: double.infinity,
                                  child: Image.network(
                                    productsList[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productsList[index].productName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),


                                  Text(
                                    '1kg, pricegm',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        '₹${productsList[index].productPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      productQuantities[productsList[index].id]!=null
                                          ? Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 20),
                                            color: _removeButtonColor ?? Colors.grey.shade500,
                                            onPressed: () async {
                                              if (quantity > 0) {
                                                setState(() {
                                                  _removeButtonColor = Colors.green;
                                                });
                                                await decreaseCartQuantity(productId);
                                                // Wait for the quantity to update in the backend
                                                await Future.delayed(Duration(milliseconds: 500));
                                                await fetchCartItems();
                                                setState(() {
                                                  if (productQuantities[productId]! <= 0) {
                                                    _selectedProductIndex = -1;
                                                  }
                                                  _removeButtonColor = null;
                                                });
                                              }
                                            },
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            width: 37,
                                            height: 37,
                                            child: Center(
                                              child: Text(
                                                '$quantity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 20),
                                            color: _addButtonColor ?? Colors.grey.shade600,
                                            onPressed: () async {
                                              setState(() {
                                                _addButtonColor = Colors.green;
                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                              setState(() {
                                                _addButtonColor = null;
                                              });
                                            },
                                          ),
                                        ],
                                      )

                                          : SizedBox(
                                        width: 37,
                                        height: 37,
                                        child: Material(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(14),
                                          child: InkWell(
                                            onTap: () async {
                                              setState(()  {
                                                _selectedProductIndex = index;

                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Groceries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next page when the image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(page: 1),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Color cardColor = Colors.accents[index %
                          Colors.accents.length];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(
                                    width: 50,
                                    child: Image.network(
                                      productsList[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 70.0),
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),


              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productsList[index];
                    final productId = product.id;
                    final quantity = productQuantities[productId] ?? 0;



                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DescriptionPage(product: productsList[index],quantity: quantity,),
                                    ),
                                  );// Replace '/nextPage' with the route name of the next page
                                },

                                child: SizedBox(
                                  height: 110,
                                  width: double.infinity,
                                  child: Image.network(
                                    productsList[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productsList[index].productName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),


                                  Text(
                                    '1kg, pricegm',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        '₹${productsList[index].productPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      productQuantities[productsList[index].id]!=null
                                          ? Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 20),
                                            color: _removeButtonColor ?? Colors.grey.shade500,
                                            onPressed: () async {
                                              if (quantity > 0) {
                                                setState(() {
                                                  _removeButtonColor = Colors.green;
                                                });
                                                await decreaseCartQuantity(productId);
                                                // Wait for the quantity to update in the backend
                                                await Future.delayed(Duration(milliseconds: 500));
                                                await fetchCartItems();
                                                setState(() {
                                                  if (productQuantities[productId]! <= 0) {
                                                    _selectedProductIndex = -1;
                                                  }
                                                  _removeButtonColor = null;
                                                });
                                              }
                                            },
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            width: 37,
                                            height: 37,
                                            child: Center(
                                              child: Text(
                                                '$quantity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 20),
                                            color: _addButtonColor ?? Colors.grey.shade600,
                                            onPressed: () async {
                                              setState(() {
                                                _addButtonColor = Colors.green;
                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                              setState(() {
                                                _addButtonColor = null;
                                              });
                                            },
                                          ),
                                        ],
                                      )

                                          : SizedBox(
                                        width: 37,
                                        height: 37,
                                        child: Material(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(14),
                                          child: InkWell(
                                            onTap: () async {
                                              setState(()  {
                                                _selectedProductIndex = index;

                                              });
                                              await increaseCartQuantity(productId);
                                              // Wait for the quantity to update in the backend
                                              await Future.delayed(Duration(milliseconds: 500));
                                              await fetchCartItems();
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }

}
class BottomNavigation extends StatefulWidget {
  final int page;
  final String? categoryName;

  const BottomNavigation({Key? key, this.page = 0, this.categoryName}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late List pages;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.page;
    pages = [
      HomePage(),
      Explore(),
      CartPage(),
      FavouritePage(),
      Account(),
      Search(categoryName: widget.categoryName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pages[_index],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: SizedBox(
            height: 77,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.black,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_outlined, size: 24),
                  label: 'Shop',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.manage_search_outlined, size: 24),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined, size: 24),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_outlined, size: 24),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 24),
                  label: 'Account',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}