import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectb/Homepage.dart';
import 'package:projectb/urlConstant/AppConstants.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  Color customGreenColor = Color(0xFF53b175);

  late String userMobileNumber ;

  @override
  void initState() {
    super.initState();
    setState(()  {
      userMobileNumber  = AppConstants.getPhoneNumber() as String;
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
          builder: (context) => BottomNavigation(page: 5,), // Replace with the desired destination
        ),
      );
      // Return false to prevent default behavior
      return false;
    },
    child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsets.only(top: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),

      ),
    body: userMobileNumber.isNotEmpty? SingleChildScrollView(
      scrollDirection: Axis.vertical,
    child: Container(
    decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40),
    topRight: Radius.circular(40),
    ),
    ),
    child: Padding(
    padding: const EdgeInsets.only(top: 37,left: 20,bottom: 50,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
              'Categories',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            buildOption('Eggs', selectedCategories, (selected) {
              setState(() {
                selected ? selectedCategories.add('Eggs') : selectedCategories.remove('Eggs');
              });
            }),
            buildOption('Noodles & Pasta', selectedCategories, (selected) {
              setState(() {
                selected ? selectedCategories.add('Noodles & Pasta') : selectedCategories.remove('Noodles & Pasta');
              });
            }),
            buildOption('Chips & Crisps', selectedCategories, (selected) {
              setState(() {
                selected ? selectedCategories.add('Chips & Crisps') : selectedCategories.remove('Chips & Crisps');
              });
            }),
            buildOption('Fast Food', selectedCategories, (selected) {
              setState(() {
                selected ? selectedCategories.add('Fast Food') : selectedCategories.remove('Fast Food');
              });
            }),
            SizedBox(height: 36),
            Text(
              'Brand',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            buildOption('Individual Collection', selectedBrands, (selected) {
              setState(() {
                selected ? selectedBrands.add('Individual Collection') : selectedBrands.remove('Individual Collection');
              });
            }),
            buildOption('Cocola', selectedBrands, (selected) {
              setState(() {
                selected ? selectedBrands.add('Cocola') : selectedBrands.remove('Cocola');
              });
            }),
            buildOption('Ifad', selectedBrands, (selected) {
              setState(() {
                selected ? selectedBrands.add('Ifad') : selectedBrands.remove('Ifad');
              });
            }),

            SizedBox(height: 50,),
            Padding(padding: EdgeInsets.only(right: 20),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/eight');
              },
              backgroundColor: customGreenColor,
              label: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

            ),
            )
          ],
        ),
      ),
    ),
    ): Center(child: CircularProgressIndicator(),),
    ),
    );
  }

  Widget buildOption(String title, List<String> selectedList, Function(bool) onChanged) {
    bool selected = selectedList.contains(title);
    return Row(
      children: [
         Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            checkColor: Colors.white,
            activeColor: selected ? customGreenColor : Colors.transparent,
            value: selected,
            onChanged: onChanged(true),
          ),

        SizedBox(width: 8),
        Text(
            title,
        style: TextStyle(fontSize: 17,
          color: selected ?customGreenColor:
          Colors.black,
        ),
    ),


      ],
    );
  }
}