import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectb/DescriptionPage.dart';
import 'package:projectb/Filters.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/models/cartItem.dart';
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'models/productsModel.dart';
import 'models/bm25.dart';



class Search extends StatefulWidget {
  final String? categoryName;

  const Search({Key? key, this.categoryName}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Color? _removeButtonColor;
  Color? _addButtonColor;
  Color customGreenColor = const Color(0xFF53b175);
  List<Product1> productsList = [];
  List<Product1> filteredProducts = [];
  Map<String, int> productQuantities = {};
  TextEditingController searchController = TextEditingController();
  BM25? bm25;
  String? userID;

  FocusNode _focusNode = FocusNode();
  Repository repository = Repository();
  int _selectedProductIndex = -1;
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _removeButtonColor = null;
    _addButtonColor = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _initializeUser();
    loadProducts();
  }

  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userID = userId;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    List<Product1> products = await repository.loadProducts();
    List<List<String>> documents = products.map((product) => product.productName.toLowerCase().split(' ')).toList();
    bm25 = BM25(documents);
    setState(() {
      productsList = products;
      filteredProducts = products;

      if (widget.categoryName != null) {
        filteredProducts.sort((a, b) {
          if (a.categoryName == widget.categoryName && b.categoryName != widget.categoryName) {
            return -1;
          } else if (a.categoryName != widget.categoryName && b.categoryName == widget.categoryName) {
            return 1;
          } else {
            return 0;
          }
        });
      }
    });
    await fetchCartItems();
  }

  void _onSearchChanged() {
    String query = searchController.text.trim().toLowerCase();
    print('Search query: $query');
    if (query.isEmpty) {
      setState(() {
        filteredProducts = widget.categoryName != null
            ? productsList.where((product) => product.categoryName == widget.categoryName).toList()
            : productsList;
      });
    } else {
      List<String> queryWords = query.split(' ');
      List<Product1> substringFiltered = productsList.where((product) {
        bool nameMatch = product.productName.toLowerCase().startsWith(query);
        bool categoryMatch = product.categoryName.toLowerCase().startsWith(query);
        return nameMatch || categoryMatch;
      }).toList();
      if (bm25 != null) {
        List<Map<String, dynamic>> searchResults = bm25!.search(queryWords);
        substringFiltered.sort((a, b) {
          int indexA = productsList.indexOf(a);
          int indexB = productsList.indexOf(b);
          double scoreA = searchResults.firstWhere((result) => result['docIndex'] == indexA)['score'];
          double scoreB = searchResults.firstWhere((result) => result['docIndex'] == indexB)['score'];
          return scoreB.compareTo(scoreA);
        });
      }
      setState(() {
        filteredProducts = substringFiltered;
      });
      print('Search results: ${filteredProducts.map((product) => product.productName).toList()}');
    }
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
    return Scaffold(
      body: userID != null && userID!.isNotEmpty?  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 53,
                      child: TextField(
                        controller: searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                          hintText: 'Search Store',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      _showFilterBottomSheet(context);
                    },
                    icon: Icon(Icons.tune),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 20, right: 20),
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1 / 1.29,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {

                  final product = filteredProducts[index];
                  final productId = product.id;
                  final quantity = productQuantities[productId] ?? 0;

                  return Container(
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
                                  builder: (context) => DescriptionPage(product: filteredProducts[index], quantity: quantity,),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Image.network(
                                filteredProducts[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredProducts[index].productName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                              Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹ ${filteredProducts[index].productPrice}',
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
                                          setState(() {
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
                  );
                },
              ),
            ),
          ),
        ],
      ) :Center(child: CircularProgressIndicator(),),
    );
  }

  _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.9,
                child: Filters(),
              ),
            ),
          ],
        );
      },
    );
  }
}