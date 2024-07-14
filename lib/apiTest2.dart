import 'package:flutter/material.dart';
import 'dart:convert'; // For json decoding
import 'package:http/http.dart' as http;



class MyApi2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch All Documents',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = "";

  Future<void> fetchAllDocuments() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/fetchall'));

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON.
        setState(() {
          _data = const JsonEncoder.withIndent('  ').convert(json.decode(response.body));
        });
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load documents: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log the error and display a message
      print('Error fetching documents: $e');
      setState(() {
        _data = 'Error fetching documents: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch All Documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchAllDocuments,
              child: Text('Fetch All'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
