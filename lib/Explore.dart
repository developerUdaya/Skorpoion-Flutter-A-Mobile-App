import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projectb/DescriptionPage.dart';
import 'package:projectb/Filters.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/Search.dart';
import 'package:http/http.dart' as http;
import 'package:projectb/repository/Repository.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:projectb/urlConstant/UrlConstant.dart';
import 'dart:convert';

import 'models/categoryModel.dart' as custom;


class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  List<custom.Category> categoryList =[];
  String? userMobileNumber ;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    loadCategory();
  }



  Future<void> loadCategory() async {
    Repository repository = Repository();
    List<custom.Category> categories = await repository.loadCategories();
    setState(() {
      categoryList = categories;
    });
  }

  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
      userMobileNumber = userId;

    });
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
            builder: (context) => BottomNavigation(page: 0,), // Replace with the desired destination
          ),
        );
        // Return false to prevent default behavior
        return false;
      },
      child:Scaffold(
        body: userMobileNumber != null && userMobileNumber!.isNotEmpty? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 29,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Find Products',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(16), // Adjust padding here
                child: SizedBox(
                  height: 53,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          size: 20,
                          color: Colors.black
                      ),
                      hintStyle: TextStyle(fontSize: 15,
                          color: Colors.grey.shade600
                      ),
                      hintText: 'Search Store',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    readOnly: true,
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> Search()),

                      );


                    },

                  ),
                ),
              ),
              SizedBox(height: 5),

              GridView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(right: 18, left:18 ),
                itemCount: categoryList.length,
                scrollDirection: Axis.vertical,// Number of items in the grid
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15, // Spacing between columns
                  mainAxisSpacing: 15, // Spacing between rows
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Color cardColor = Colors.accents[index % Colors.accents.length];
                  final Color borderColor = cardColor.withOpacity(0.2);

                  return Container(

                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(page: 5, categoryName: categoryList[index].categoryName),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            categoryList[index].imageUrl,
                            // Placeholder image URL
                            height: 70,
                            width: double.infinity,
                            fit: BoxFit.contain,

                          ),

                          SizedBox(height: 20),

                          Text(
                            categoryList[index].categoryName,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ) :Center(child: CircularProgressIndicator(),),

      ),
    );
  }
}