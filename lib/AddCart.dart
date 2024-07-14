import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/OrderAccepted.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectb/PorterUtils.dart';
import 'package:projectb/couponPage.dart';
import 'package:projectb/models/addressModel.dart';
import 'package:projectb/PorterUtils.dart';
import 'package:projectb/porter/getquote.dart';
import 'package:projectb/porter/models/getQuoteModel.dart';
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'models/paymentModel.dart';
import 'models/productsModel.dart';
import 'models/cartItem.dart';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';




class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Color? _removeButtonColor;
  Color? _addButtonColor;
  Color customGreenColor = Color(0xFF53b175);
  Color customGreenColor1 = Color(0xFF489e67);

  double productsPrice=0;

  // int delivery = 100;
  List<CartItem> cartItems = [];
  List<Product1> products = [];
  List<String> cartItemsId = [];
  List<Address> list = [];
  PorterUtils? porterUtils ;
  Razorpay? _razorpay;


  String? userID;

  PickupDetails pickupDetails = PickupDetails(lat: 12.935025018880504, lng: 77.6092605236106);

  DropDetails? dropDetails;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    _removeButtonColor = null;
    _addButtonColor = null;
    _razorpay = Razorpay();

    _initializeUser();
    loadProducts();
    fetchAddressData();

  }

  Future<void> loadProducts() async {
    Repository repository = Repository();

    print("Loading cart items...");

    cartItems = await repository.loadCartItems();
    cartItemsId = cartItems.map((cartItem) => cartItem.id).toList();

    print("Cart item IDs: $cartItemsId");

    products = await repository.loadProducts();

    print("Loaded products: ${products.map((e) => e.productName).join(', ')}");
    print("Product IDs: ${products.map((e) => e.id).join(', ')}");

    setState(() {
      products = products.where((product) => cartItemsId.contains(product.id)).toList();
      print("Filtered products: ${products.map((e) => e.productName).join(', ')}");
    });

    updateProductPrice();
  }


  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  void updateProductPrice(){
    double price=0;
    for (Product1 product in products) {
      price += product.productPrice * cartItems.firstWhere((cartItem) => cartItem.id==product.id).productCartQuantity;
    }
    setState(() {
      productsPrice = price;
    });
  }


  Future<void> increaseCartQuantity(String productId) async {
    Repository repository = Repository();
    await repository.increaseCartQuantity(productId);
    loadProducts();
  }

  Future<void> decreaseCartQuantity(String productId) async {
    Repository repository = Repository();
    await repository.decreaseCartQuantity(productId);
    loadProducts();
  }

  Future<void> deleteCartItem(String productId) async {
    Repository repository = Repository();
    await repository.deleteCartItem(productId);
    loadProducts();
  }


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);



    print("paymentId: ${response.paymentId}");
    print("order iD : ${response.orderId}");
    print("amount : ₹${productsPrice}");
    print("PaymentStatus: success");
    // print("Payment Method: $paymentMethod");
    print("User Name: "); // Replace with actual user name
    print("Payment Date: ${DateTime.now().toIso8601String()}");

    final paymentDetails = PaymentDetails(
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: productsPrice,
      paymentStatus: 'success',
      paymentMethod: '', // Replace with actual payment method if available
      // Replace with actual user name if available
      name: '', // Replace with actual name if available
      mobileNumber: '',
      userid: '',
      paymentDate: DateTime.now().toIso8601String(),
    );



    var url = '${URLConstants.addPaymentDetails}?user_id=$userID'; // Replace with your server address
    var responseDB;
    try {
      responseDB = await http.post(
        Uri.parse(url),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode(paymentDetails.toJson()),
      );

      print("after response");

      if (responseDB.statusCode == 200) {
        var responseData = jsonDecode(responseDB.body);
        print("Response data: ${responseData["message"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful and order stored!')),
        );
        print("success DB");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful but failed to store order.')),
        );
        print("error fetching dB: ${responseDB.statusCode}");
      }
    } catch (e) {
      print("Error posting payment details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to store payment details.')),
      );

      await Future.delayed(Duration(seconds: 30)); // Replace with actual delay or event listener

      // Assuming payment is successful, add order history and navigate

      PorterUtils();

      // Navigate to payment successful page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderAcceptedPage(),
        ),
      );



    }


  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);

    print("Amount Paid: ₹${productsPrice}");
    print("Payment Status: failed");
    print("Payment Date: ${DateTime.now().toIso8601String()}");
    // Optionally, navigate to an error page or show an error message
    // showDialog(optins
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text("Payment Failed"),
    //     content: Text("Error Code: ${response.code}\nMessage: ${response.message}"),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text("Retry"),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  void openPaymentPortal() async {
    int amountInPaise = (productsPrice * 100).toInt(); // Convert to paise

    // Extract product name (assuming you want the first item's name)
    String productname = products.map((e) => e.productName).join(", ");


    var options = {
      'key': '${URLConstants.RazorpayApiKey}',
      'amount': amountInPaise,
      'name': '',
      'productname':productname,
      'description': 'Payment',
      // 'timeout':90,
      // 'prefill': {'contact': '9999999999',
      //   'email': 'jhon@razorpay.com'},

    };
    try {
      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      _razorpay?.open(options);
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(
          msg: "Error opening Razorpay: $e", timeInSecForIosWeb: 4);
    }
  }



  Future<void> addOrderHistory() async {
    try {

      print(1);
      final response = await http.post(
        Uri.parse('${URLConstants.addOrderHistory}?user_id=$userID'),
        headers: {"Content-Type": "application/json"},
      );
      print(2);

      if (response.statusCode == 200) {
        // Parse the JSON response
        print(333);

        Map<String, dynamic> responseData = json.decode(response.body);
        print('Order History Response: $responseData');

        print(3);

        // Navigate to the order accepted page
        print(4);


        //TODO modify the below code to delete all cart items using single api , don't use for loop
        for (var item in cartItems) {
          await deleteCartItem(item.id);
        }

        print(5);


        print(6);

      } else {
        print('Failed to add order history: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
        throw Exception('Failed to add order history: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error adding order history: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<void> fetchAddressData() async {


    const userID = 9003205532;
    final String addressUrl = '${URLConstants.fetchAddress}?user_id=$userID';

    try {
      final response = await http.get(
        Uri.parse(addressUrl),
      );

      if (response.statusCode == 200) {
        print('response: ${response.body}');
        List<dynamic> addressJsonResponse = json.decode(response.body);

        List<Address> fetchedAddress = [];
        for (var entry in addressJsonResponse) {

          Map<String, dynamic> userMap = entry['user'];
          if (userMap != null && userMap.containsKey(userID.toString())) {
            Map<String, dynamic> addressData = entry['user'][userID.toString()];

            if (addressData != null) {
              Map<String, dynamic> addressMap = addressData['address'];

              for (var addEntry in addressMap.entries) {
                String type = addEntry.key;
                Map<String, dynamic> typeData = addEntry.value;


                for (var addressEntry in typeData.entries) {
                  Map<String, dynamic> data = addressEntry.value;
                  Address address = Address.fromJson(data);

                  print(address.toString());

                  address.addressType = type;
                  fetchedAddress.add(address);
                }
              }
            } else {
              print('Error: User ID not found in response');
            }
          }
        }

        setState(() {
          list = fetchedAddress;
          print(fetchedAddress.map((e) => e.addressType,).join(', '));
          print("fetchedAddress.map((e) => e.addressType).join(', ')");

        });

        if (fetchedAddress.isNotEmpty) {
          Address address = fetchedAddress.first;

          print('lat:${address.lat},lng:${address.lng}');
          dropDetails = DropDetails(
            lat: double.parse(address.lat),
            lng: double.parse(address.lng),
          );
          print('DropDetails: ${dropDetails.toString()}');

          customer = Customer(
            name: address.name,
            mobile: Mobile(
              countryCode: '+91', number: '${AppConstants.getPhoneNumber()}',
            ),
          );


          print('Customer: $customer');

        } else {
          print('Error: No address found for the user');
        }
      } else {
        print('Error fetching address data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught while fetching address data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // For example, navigate to homepage

        // Return false to prevent default behavior
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'My Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: userID != null && userID!.isNotEmpty? SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5), // below my cart
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      thickness: 0.7,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 0), // below first line
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        int quantity = cartItems.firstWhere((cartItem) => cartItem.id==products[index].id).productCartQuantity;
                        double itemTotalPrice = products[index].productPrice*quantity;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                                  child: Container(
                                    width: 70,
                                    height: 121,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            products[index].imageUrl),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          products[index].productName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 75),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          color: Colors.grey.shade400,
                                          iconSize: 19,
                                          onPressed: () async {
                                            await deleteCartItem(products[index].id);
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '1kg, Price',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                        height: -1.1,
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 37,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            alignment: Alignment.center,
                                            iconSize: 20,
                                            icon: Icon(Icons.remove),
                                            color: _removeButtonColor ?? Colors.grey.shade500,
                                            onPressed: () async {
                                              setState(() {
                                                cartItems[index].productCartQuantity = (cartItems[index].productCartQuantity - 1).clamp(0, 99);
                                                _removeButtonColor = Colors.green;
                                              });
                                              Future.delayed(Duration(milliseconds: 200), () {
                                                setState(() {
                                                  _removeButtonColor = null;
                                                });
                                              });
                                              await decreaseCartQuantity(products[index].id);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 37,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            alignment: Alignment.center,
                                            iconSize: 20,
                                            icon: Icon(Icons.add),
                                            color: _addButtonColor ?? Colors.grey.shade600,
                                            onPressed: () async {
                                              setState(() {
                                                cartItems[index].productCartQuantity = (cartItems[index].productCartQuantity + 1).clamp(0, 99);
                                                _addButtonColor = Colors.green;
                                              });
                                              Future.delayed(Duration(milliseconds: 200), () {
                                                setState(() {
                                                  _addButtonColor = null;
                                                });
                                              });
                                              await increaseCartQuantity(products[index].id);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 72),
                                        Text(
                                          '₹$itemTotalPrice',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Divider(
                              height: 1,
                              thickness: 0.7,
                              color: Colors.grey[300],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator(),),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 284,
                height: 52,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .bottom,
                                ),
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(
                                      bottom: 30, top: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 10, 0, 20),
                                                child: Text(
                                                  'Checkout',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 200),
                                              IconButton(
                                                icon: Icon(Icons.close),
                                                color: Colors.black,
                                                iconSize: 24,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey[300],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 14, 0, 14),
                                                child: Text(
                                                  'Sub total',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 180.5),


                                              Text(
                                                '₹$productsPrice',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                              ),

                                              SizedBox(width: 3,),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                color: Colors.black,
                                                iconSize: 14,
                                                onPressed: () {},
                                              ),


                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 14, 20, 14),
                                                child: Text(
                                                  'Delivery',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 194.5),

                                              Text(
                                                '0',

                                              ),


                                              IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_forward_ios),
                                                  color: Colors.black,
                                                  iconSize: 14,
                                                  onPressed:(){}
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 14, 0, 14),
                                                child: Text(
                                                  'Coupon Code',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 109),

                                              GestureDetector(
                                                onTap: () {
                                                  // Navigate to the next page when the image is tapped


                                                },
                                                child: Text(
                                                  'Pick discount',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                color: Colors.black,
                                                iconSize: 14,
                                                onPressed: () {},
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 14, 0, 14),
                                                child: Text(
                                                  'Total Cost',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 180),

                                              Text(
                                                '₹${productsPrice}', //+ delivery}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                color: Colors.black,
                                                iconSize: 14,
                                                onPressed: () {},
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 15, 0, 0),
                                                child: Text(
                                                  'By placing an order you agree to our',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                child: Text(
                                                  'Terms',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ' And',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                ' Conditions',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: SizedBox(
                                              width: 314,
                                              height: 62,
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  // Open payment portal
                                                  // openPaymentPortal();
                                                  PorterUtils();

                                                  // Wait for payment completion before proceeding

                                                },
                                                color: customGreenColor,
                                                textColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                ),
                                                child: Text("Place Order",
                                                  style: TextStyle(

                                                    fontSize: 18,

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
                              );
                            },
                          );
                        },
                        color: customGreenColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text("Go to Checkout"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7,
                              vertical: 2),
                          decoration: BoxDecoration(
                            color: customGreenColor1,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '₹$productsPrice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
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