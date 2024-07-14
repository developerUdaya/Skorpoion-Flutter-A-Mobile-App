import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projectb/Account.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/OrderHist.dart';
import 'package:projectb/models/cartItem.dart';
import 'package:projectb/models/productsModel.dart';

import 'package:projectb/models/orderhistoryModel.dart';
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  Color customGreenColor = Color(0xFF53b175);

  List<Product1> products = [];
  List<OrderHistory> orderHistory = [];
  List<OrderHistory> orderHistoryList = [];

  bool isLoading = true;

   String? userID;

  @override
  void initState() {
    super.initState();
     _initializeUser();
     loadOrderHistory();
  }

  Future<void> loadOrderHistory() async {

    Repository repository = Repository();

    setState(() async {
      orderHistory = await repository.loadOrderHistory();
      orderHistoryList = await repository.loadOrderHistory();
    });

  }

  Future<void> fetchOrderHistory() async {
    try {
      const userID = "9003205532"; // Replace with the actual user ID
      final response = await http.get(
        Uri.parse('${URLConstants.fetchOrderHistory}?user_id=$userID'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Print the raw JSON response for debugging
        print('Order History Response body: ${response.body}');

        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        List<OrderHistory> orders = [];
        for (var userData in jsonResponse) {
          if (userData['user'] != null && userData['user'][userID] != null && userData['user'][userID]['orderHistory'] != null) {
            var orderHistoryData = userData['user'][userID]['orderHistory'];

            for (var orderEntry in orderHistoryData.entries) {
              String orderID = orderEntry.key;
              Map<String, dynamic> orderDetails = orderEntry.value;

              Map<String, Product1> productsMap = {};
              for (var productEntry in orderDetails['products'].entries) {
                String productId = productEntry.key;
                int productCartQuantity = productEntry.value['productCartQuantity'] ?? 0;

                print('Fetching product details for product ID: $productId');

                // Fetch product details by product ID
                final productResponse = await http.get(
                  Uri.parse('${URLConstants.fetchpid}?product_id=$productId'),
                );

                if (productResponse.statusCode == 200) {
                  List<dynamic> productJsonResponseList = json.decode(productResponse.body);

                  if (productJsonResponseList.isNotEmpty) {
                    Map<String, dynamic> productJsonResponse = productJsonResponseList[0];

                    if (productJsonResponse.containsKey('products')) {
                      Map<String, dynamic> products = productJsonResponse['products'];

                      if (products.containsKey(productId)) {
                        // Get the product JSON for the specified product ID
                        Map<String, dynamic> productJson = products[productId];
                        Product1 product = Product1.fromJson(productJson);

                        // Update the product's cart quantity
                        int productCart = productCartQuantity;

                        productsMap[productId] = product;

                        // Print the product details for debugging
                        print(product.toString());
                      } else {
                        print('Product not found in response for product ID: $productId');
                      }
                    } else {
                      print('Products key not found in product JSON response');
                    }
                  } else {
                    print('Empty product JSON response');
                  }
                } else {
                  print('Failed to load product details for product ID: $productId');
                }
              }

              OrderHistory orderHistory = OrderHistory.fromJson(orderDetails);
              orders.add(orderHistory);
            }
          } else {
            print('Invalid JSON structure or missing keys.');
          }
        }

        // Print the parsed orders for debugging
        for (int i = 0; i < orders.length; i++) {
          print(orders[i].toString());
        }

        setState(() {
          orderHistoryList = orders;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load order history: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching order history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(page: 4),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 17,
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(page: 4),
                ),
              );
            },
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Order History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body:  userID != null && userID!.isNotEmpty? SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderHistoryList.length,
                itemBuilder: (context, index) {
                  final order = orderHistoryList[index];
                  return InkWell(
                    onTap: () {
                      // Handle the tap event
                      // For example, navigate to order details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Orderhist(),
                        ),
                      );
                    },
                    child: OrderCard(order: order),
                  );
                },
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderHistory order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Chip(
                    label: Text(
                      order.orderStatus,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Colors.green.shade50.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.green.shade200,
                        width: 0,
                      ),
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                ],
              ),
              SizedBox(height: 4), // Add some space between the title and order ID
              Text(
                'Order ID: ${order.orderID}', // Use orderID here
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                order.deliveryDate,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.products.map((product) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.productName,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            '${product.productCartQuantity} x ${product.price}',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ₹${order.products.fold(0.0, (sum, item) => sum + (item.price * item.productCartQuantity))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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


