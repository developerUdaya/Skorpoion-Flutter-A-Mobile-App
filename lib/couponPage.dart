import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Coupons',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            CouponCard(
              code: 'TREAT60',
              description: '₹60 Off on orders worth ₹200 or more',
              discount: 'Save ₹60\nwith this offer',
            ),
            SizedBox(height: 10),
            CouponCard(
              code: 'PIZZA50',
              description: 'Get flat ₹50 Off on orders of ₹200 or more',
              discount: 'Save ₹50\nwith this offer',
            ),
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatefulWidget {
  final String code;
  final String description;
  final String discount;

  const CouponCard({
    Key? key,
    required this.code,
    required this.description,
    required this.discount,
  }) : super(key: key);

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isApplied = false;

  void _toggleApplied() {
    setState(() {
      isApplied = !isApplied;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 25, right: 10,bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'OFF',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            padding: EdgeInsets.all(5),
                            color: Colors.grey,
                            child: Text(
                              widget.code,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineLength: double.infinity,
                    lineThickness: 2.0,
                    dashLength: 4.0,
                    dashColor: Colors.grey.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
               SizedBox(height: 20,),
                    Text(
                      widget.discount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
              ),

                Divider(color: Colors.grey.shade100),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _toggleApplied,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isApplied) ...[
                          Icon(Icons.done_all, color: Colors.green),
                          SizedBox(width: 5),
                        ],
                        Text(
                          isApplied ? 'Applied' : 'Apply Now',
                          style: TextStyle(
                            color: isApplied ? Colors.green : Colors.red.shade500,
                            fontSize: 18,
                          ),
                        ),
                      ],
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

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 20.0;
    const smallRadius = 10.0;

    Path path = Path()
      ..moveTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius), clockwise: false)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius), clockwise: false)
      ..moveTo(0, size.height / 2 - smallRadius)
      ..arcToPoint(Offset(0, size.height / 2 + smallRadius), radius: Radius.circular(smallRadius))
      ..moveTo(size.width, size.height / 2 - smallRadius)
      ..arcToPoint(Offset(size.width, size.height / 2 + smallRadius), radius: Radius.circular(smallRadius))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}