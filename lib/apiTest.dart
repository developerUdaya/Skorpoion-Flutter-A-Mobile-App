import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _response = '';

  Future<void> fetchData() async {

    try {
      // Make a GET request to your API
      var url = Uri.http('http://127.0.0.1:8080/fetchall', '/');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, set the response data
        setState(() {
          _response = response.body;
        });
      } else {
        // If the server returns an error response, display the error message
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }

      print(_response);
    } catch (error) {
      // If an error occurs during the request, display the error message
      setState(() {
        _response = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Text(
              'Response:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
