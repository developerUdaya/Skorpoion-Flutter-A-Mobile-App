import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'dart:convert';
import 'models/productsModel.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  Repository repository = Repository();

  Color customGreenColor = Color(0xFF53b175);
  Color customGreenColor1 = Color(0xFF489e67);
  List<Product1> products = [];
  bool isLoading = true;

  String? userID;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    _initializeUser();
  }



  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;

    });
  }

  Future<void> fetchFavorites() async {
    setState(() {
      isLoading = true;
    });
    Repository repository = Repository();
    await repository.fetchFavorites();
    List<Product1> favoriteProducts = await repository.loadFavourites();
    setState(() {
      products = favoriteProducts;
      isLoading = false;
    });

  }

  Future<void> deleteFavoriteItem(String productId) async {
    Repository repository = Repository();
    await repository.removeFromFavorites(productId);
    await fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(page: 0),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Favourite',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body:  userID != null && userID!.isNotEmpty?  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      thickness: 0.7,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 0),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : products.isEmpty
                        ? Center(child: Text('No favorite items'))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = products[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Container(
                                    width: 60,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: NetworkImage(product.imageUrl),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "1Kg, Price",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${product.productPrice}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.grey.shade400,
                                  iconSize: 19,
                                  onPressed: () async {
                                    await deleteFavoriteItem(product.id);
                                  },
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
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(page: 2),
                      ),
                    );
                  },
                  color: customGreenColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text("Add All To Cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}