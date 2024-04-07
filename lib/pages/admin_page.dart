import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

import 'package:cloud_functions/cloud_functions.dart';


//initialize client SDK
final functions = FirebaseFunctions.instance;





Future<List<dynamic>> getFruit() async {
  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('on_request_example');
    final results = await callable();
    final reqData = results.data;
    print("result: $reqData");
    if (reqData is List<dynamic>) {
      return reqData;
    } else {
      throw Exception('Unexpected data format returned from Cloud Function');
    }
  } catch (e) {
    print("Error calling Cloud Function: $e");
    throw Exception('Failed to get fruit: $e');
  }
}


class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() {
    return _AdminScreenState();
  }
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<dynamic>>? _futureFruit; // Define Future for getFruit function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Fruit Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _futureFruit = getFruit();
                });
              },
              child: Text('Get Fruit'),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _futureFruit,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text('Fruits:'),
                      SizedBox(height: 10),
                      for (var fruit in snapshot.data!)
                        Text(fruit.toString()),
                    ],
                  );
                } else {
                  return SizedBox(); // Return an empty widget if no data is available
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
