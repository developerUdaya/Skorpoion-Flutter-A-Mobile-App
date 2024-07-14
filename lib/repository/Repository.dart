import 'package:projectb/models/addressModel.dart';
import 'package:projectb/models/cartItem.dart';
import 'package:projectb/models/categoryModel.dart';
import 'package:projectb/models/orderhistoryModel.dart';
import 'package:projectb/models/paymentModel.dart';
import 'package:projectb/models/productsModel.dart';
import 'package:projectb/urlConstant/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../urlConstant/UrlConstant.dart';

class Repository {
  List<Product1> products = [];
  List<CartItem> cartItems = [];
  List<Category> category = [];
  List<OrderHistory> orderHistory = [];
  List<Address> address = [];
  List<String> favourites = [];

  Future<String?> userID = AppConstants.getPhoneNumber();

  Future<void> saveProducts(List<Product1> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('products', jsonList);
    print('Products saved to SharedPreferences');
  }

  Future<List<Product1>> loadProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('products');

    if (jsonList != null) {
      products = jsonList.map((jsonItem) => Product1.fromJson(jsonDecode(jsonItem))).toList();
    }

    // Debug: Print products loaded from SharedPreferences
    print('Products loaded from SharedPreferences: ${products.map((e) => e.productName).join(', ')}');

    if (products.isNotEmpty) {
      return products;
    } else {
      print('No products found in SharedPreferences, fetching from server...');
      return fetchProducts();
    }
  }

  Future<List<Product1>> fetchProducts() async {
    List<Product1> products = [];
    try {
      final response = await http.get(Uri.parse(URLConstants.fetchProduct));

      if (response.statusCode == 200) {
        // Print the raw JSON response for debugging
        print('Response body: ${response.body}');

        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);
        print('Parsed JSON response: $jsonResponse');

        if (jsonResponse.isEmpty) {
          throw Exception('Empty JSON response');
        }

        // Extract the products map
        Map<String, dynamic> productsMap = jsonResponse[0]['products'];
        print('Products map: $productsMap');

        if (productsMap == null || productsMap.isEmpty) {
          throw Exception('Products map is empty or null');
        }

        // Iterate through the products map
        productsMap.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            products.add(Product1.fromJson(value));
          }
        });

        // Print the parsed products for debugging
        for (int i = 0; i < products.length; i++) {
          print(products[i].toString());
        }

        // Save the products to SharedPreferences
        await saveProducts(products);

        // Return the fetched products
        return products;

      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load products: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log the error and display a message
      print('Error fetching products: $e');
      return products; // Return an empty list in case of error
    }
  }


  Future<void> saveCartItems(List<CartItem> cartItems) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = cartItems.map((cartItem) => jsonEncode(cartItem.toJson())).toList();
    await prefs.setStringList('cartItems', jsonList);
    print('Cart items saved to SharedPreferences');
  }


  Future<List<CartItem>> loadCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('cartItems');
    if (jsonList != null) {
      cartItems = jsonList.map((jsonItem) => CartItem.fromJson(jsonDecode(jsonItem))).toList();
    }

    print("load cart items");

    if (cartItems.isNotEmpty) {
      print("load cart items is not empty");

      return cartItems;
    } else {
      return fetchCartItems();
    }
  }

  Future<String?> getMobileNumber() async {
    String? number = await AppConstants.getPhoneNumber();
    return number;
  }


  Future<List<CartItem>> fetchCartItems() async {
    List<CartItem> cartItems = [];
    try {
      String? mobileNumber = await getMobileNumber();

      print("mobileNumber");
      print(mobileNumber);
      final response = await http.get(Uri.parse('${URLConstants.fetchCart}?user_id=$mobileNumber'));

      // Print the entire response for debugging
      print('Full response: ${response.toString()}');

      if (response.statusCode == 200) {
        String responseBody = response.body;

        // Print the raw JSON response for debugging
        print('Raw JSON response: $responseBody');

        // Check if the response body is null or empty
        if (responseBody == null || responseBody.isEmpty) {
          print('Empty or null response body');
        } else {
          var jsonResponse;
          try {
            jsonResponse = jsonDecode(responseBody);
          } catch (e) {
            print('Error decoding JSON: $e');
            return cartItems; // Return empty list if JSON decoding fails
          }

          // Check if jsonResponse is a list
          if (jsonResponse is List) {
            // Assuming only one user object in the list
            var userObject = jsonResponse.first['user'];
            if (userObject != null) {
              var phoneNumberKey = userObject.keys.first;
              var cartItemsMap = userObject[phoneNumberKey]['cart'];

              if (cartItemsMap != null && cartItemsMap is Map) {
                cartItemsMap.forEach((key, value) {
                  cartItems.add(CartItem.fromJson(value));
                });
              } else {
                print('Unexpected JSON structure: no cart items map');
              }
            } else {
              print('Unexpected JSON structure: no user object');
            }
          } else {
            print('Unexpected JSON format: not a list');
          }
        }

        await saveCartItems(cartItems);
      } else {
        print('Failed to load cart items, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }

    print('Loaded cart items: ${cartItems.map((e) => e.id).join(', ')}');
    return cartItems;
  }

  Future<void> increaseCartQuantity(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${URLConstants.increaseCart}?user_id=${await getMobileNumber()}&product_id=$productId'),
      );

      if (response.statusCode == 200) {
        for (CartItem cartItem in cartItems) {
          if (cartItem.id == productId) {
            cartItem.productCartQuantity++;
            break;
          }
        }

        await saveCartItems(cartItems);
      } else {
        throw Exception('Failed to increment cart item: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error incrementing cart item: $e');
    }
  }

  Future<void> decreaseCartQuantity(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${URLConstants.decreaseCart}?user_id=${await getMobileNumber()}&product_id=$productId'),
      );

      if (response.statusCode == 200) {
        for (CartItem cartItem in cartItems) {
          if (cartItem.id == productId && cartItem.productCartQuantity > 1) {
            cartItem.productCartQuantity--;
            break;
          }
        }

        await saveCartItems(cartItems);
      } else {
        throw Exception('Failed to decrement cart item: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error decrementing cart item: $e');
    }
  }

  Future<void> deleteCartItem(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('${URLConstants.deleteCart}?user_id=${await getMobileNumber()}&cart_id=$productId'),
      );

      if (response.statusCode == 200) {
        cartItems.removeWhere((cartItem) => cartItem.id == productId);
        await saveCartItems(cartItems);
      } else {
        throw Exception('Failed to delete cart item: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }

  Future<void> saveOrderHistory(List<OrderHistory> orderHistory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = orderHistory.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList('orderHistory', jsonList);
  }

  Future<List<OrderHistory>> loadOrderHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('orderHistory');
    if (jsonList != null) {
      orderHistory = jsonList.map((jsonItem) => OrderHistory.fromJson(jsonDecode(jsonItem))).toList();
    }

    if (orderHistory.isNotEmpty) {
      return orderHistory;
    } else {
      return fetchOrderHistory();
    }
  }

  Future<List<OrderHistory>> fetchOrderHistory() async {
    final response = await http.get(Uri.parse('${URLConstants.fetchOrderHistory}?user_id=${AppConstants.mobileNumber}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      orderHistory = jsonResponse.map((data) => OrderHistory.fromJson(data)).toList();
      saveOrderHistory(orderHistory);

      return orderHistory;
    } else {
      print('Failed to load order history');
      return orderHistory;
    }
  }


  Future<void> saveCategories(List<Category> category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = category.map((category) => jsonEncode(category.toJson())).toList();
    await prefs.setStringList('categories', jsonList);
    print('Categories saved to SharedPreferences');
  }

  Future<List<Category>> loadCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('categories');
    if (jsonList != null) {
      category = jsonList.map((jsonItem) => Category.fromJson(jsonDecode(jsonItem))).toList();
      print('Categories loaded from SharedPreferences');
    }

    if(category.isNotEmpty){
      return category;
    }else{
      return fetchAllCategory();
    }
  }

  Future<List<Category>> fetchAllCategory() async {

    try {
      final response = await http.get(Uri.parse(URLConstants.fetchcategory));

      if (response.statusCode == 200) {
        // Print the raw JSON response for debugging
        print('Response body: ${response.body}');

        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isEmpty) {
          throw Exception('Empty JSON response');
        }

        // Check the first item in the list which should be a map
        if (jsonResponse[0] is! Map<String, dynamic>) {
          throw Exception('Expected a map as the first item in the list');
        }

        // Extract the products map
        Map<String, dynamic> productsMap = jsonResponse[0]['category'];
        if (productsMap == null || productsMap.isEmpty) {
          throw Exception('Products map is empty or null');
        }


        // Iterate through the products map
        productsMap.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            category.add(Category.fromJson(value));
          }
        });

        // Print the parsed products for debugging
        for (int i = 0; i < category.length; i++) {
          print(category [i].toString());
        }

        await saveCategories(category);
        print('Categories loaded from the server');
        return category;

      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load documents: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log the error and display a message
      print('Error fetching documents: $e');
      return category;
    }
  }

  Future<void> saveAddresses(List<Address> address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = address.map((address) => jsonEncode(address.toJson())).toList();
    await prefs.setStringList('addresses', jsonList);
    print('Address saved to SharedPreferences');
  }

  Future<List<Address>> loadAddresses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('addresses');
    if (jsonList != null) {
      address = jsonList.map((jsonItem) => Address.fromJson(jsonDecode(jsonItem))).toList();
      print('Address loaded from SharedPreferences');
    }
    if(address.isNotEmpty){
      return fetchAddresses();
    }else{
      return fetchAddresses();
    }
  }

  Future<List<Address>> fetchAddresses() async {
    try {
      final userId = await AppConstants.getPhoneNumber(); // Ensure userID is fetched correctly
      final response = await http.get(Uri.parse('${URLConstants.fetchAddress}?user_id=$userId'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        List<dynamic> addressJsonResponse = json.decode(response.body);
        if (addressJsonResponse.isEmpty) {
          throw Exception('Empty address JSON response');
        }

        // Temporary list to store addresses
        List<Address> fetchedAddresses = [];

        for (var entry in addressJsonResponse) {
          Map<String, dynamic> userData = entry['user'][userId];
          if (userData == null) {
            throw Exception('User data not found for user $userId');
          }

          Map<String, dynamic> addressMap = userData['address'];
          if (addressMap == null) {
            throw Exception('Address map not found for user $userId');
          }

          for (var addressEntry in addressMap.values) {
            Map<String, dynamic> addressData = addressEntry;
            bool isChecked = addressData['isChecked'] == 'true'; // Parse isChecked as a boolean
            addressData['isChecked'] = isChecked;

            Address address = Address.fromJson(addressData);

            fetchedAddresses.add(address);
          }
        }

        // Print the parsed addresses for debugging
        for (int i = 0; i < fetchedAddresses.length; i++) {
          print(fetchedAddresses[i].toString());
        }

        // Save addresses to SharedPreferences
        await saveAddresses(fetchedAddresses);
        print('Address loaded from the server');
        return fetchedAddresses;

      } else {
        throw Exception('Failed to load addresses: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error loading addresses: $e');
      return [];
    }
  }



  Future<void> saveFavourites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourites', favourites);
  print("Favourite saved to SharedPreference");
  }

  Future<List<Product1>> loadFavourites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('favourites');
    List<Product1> favouriteProducts = [];

    if (jsonList != null) {
      favouriteProducts = jsonList.map((jsonItem) => Product1.fromJson(jsonDecode(jsonItem))).toList();
    }

    return favouriteProducts;
  }

  Future<void> fetchFavorites() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = await AppConstants.getPhoneNumber();
      final response = await http.get(Uri.parse('${URLConstants.fetchfavourite}?user_id=$userId'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        List<dynamic> favoriteJsonResponse = json.decode(response.body);
        if (favoriteJsonResponse.isEmpty) {
          throw Exception('Empty favorite JSON response');
        }

        List<Product1> favoriteProducts = [];

        for (var entry in favoriteJsonResponse) {
          Map<String, dynamic> userData = entry['user'][userId];
          if (userData == null) {
            throw Exception('User data not found for user $userId');
          }

          Map<String, dynamic> favouriteMap = userData['favourite'];
          if (favouriteMap == null) {
            throw Exception('Favourite map not found for user $userId');
          }

          for (var favouriteEntry in favouriteMap.values) {
            String productId = favouriteEntry['id'];

            print('Fetching product details for product ID: $productId');

            final productResponse = await http.get(Uri.parse('${URLConstants.fetchpid}?product_id=$productId'));

            if (productResponse.statusCode == 200) {
              List<dynamic> productJsonResponseList = json.decode(productResponse.body);

              if (productJsonResponseList.isNotEmpty) {
                Map<String, dynamic> productJsonResponse = productJsonResponseList[0];

                if (productJsonResponse.containsKey('products')) {
                  Map<String, dynamic> productsMap = productJsonResponse['products'];

                  if (productsMap.containsKey(productId)) {
                    Map<String, dynamic> productJson = productsMap[productId];
                    Product1 product = Product1.fromJson(productJson);

                    favoriteProducts.add(product);
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
        }

        for (int i = 0; i < favoriteProducts.length; i++) {
          print(favoriteProducts[i].toString());
        }

        favourites = favoriteProducts.map((product) => jsonEncode(product.toJson())).toList();
        await saveFavourites();

      } else {
        throw Exception('Failed to load favorites: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> addToFavorites(String productId) async {
    final userId = await AppConstants.getPhoneNumber();
    final url = '${URLConstants.addToFavourites}?user_id=$userId&product_id=$productId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        await fetchFavorites();  // Refresh the favorites after adding
        print('Product added to favorites');
      } else {
        throw Exception('Failed to add product to favorites: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    final userId = await AppConstants.getPhoneNumber();
    final url = '${URLConstants.deleteFavourite}?user_id=$userId&favourite_id=$productId';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        await fetchFavorites();  // Refresh the favorites after removal
        print('Product removed from favorites');
      } else {
        throw Exception('Failed to remove product from favorites: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  Future<bool> fetchFavoriteStatus(String productId) async {
    try {
      final userId = await AppConstants.getPhoneNumber();
      final response = await http.get(Uri.parse('${URLConstants.fetchfavourite}?user_id=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> favoriteJsonResponse = json.decode(response.body);
        if (favoriteJsonResponse.isNotEmpty) {
          Map<String, dynamic> userFavorites = favoriteJsonResponse[0]['user'][userId]['favourite'];
          print('Fetched Favourite Status');
          return userFavorites != null && userFavorites.containsKey(productId);

        }
      } else {
        throw Exception('Failed to load favorites: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error loading favorite status: $e');
    }
    return false;
  }


}