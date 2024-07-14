import 'package:flutter/material.dart';
import 'package:projectb/OrderHistoryPage.dart';

class Orderhist extends StatefulWidget {
  const Orderhist({super.key});

  @override
  State<Orderhist> createState() => _OrderhistState();
}

class _OrderhistState extends State<Orderhist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('          Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistoryPage(),
              ),

            );

          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Delivered to\n2735, 6th cross street Srinagar, Sendur Puram Extension, Kattupakkam, Chennai',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.green),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Delivered',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text('on 09 Mar 2024    01:33'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'You\'ve Saved ₹100 On This Order \🎉',
                      style: TextStyle(color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #254',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(' 09 Mar 2024 01:04  |  4 Items '),
                    Divider(),
                    buildOrderItem('3 x Onion', '₹207.0'),
                    buildOrderItem('1 x Paneer & Capsicum with Videshi Hot Sauce', '₹109.0'),
                    Divider(),
                    buildOrderSummaryItem('Sub Total', '₹316.00'),
                    buildOrderSummaryItem('Discount', '₹100.00'),
                    buildOrderSummaryItem('Taxes & Charges', '₹70.80'),
                    Divider(),
                    buildOrderSummaryItem('Grand Total', '₹287.00'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange[800],
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  // Handle reorder action
                },
                child: Text(
                  'Reorder',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOrderItem(String itemName, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(itemName)),
          Text(price),
        ],
      ),
    );
  }

  Widget buildOrderSummaryItem(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}