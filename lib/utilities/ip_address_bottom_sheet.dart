import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchIpAddress() async {
  final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['ip'];
  } else {
    throw Exception('Failed to fetch IP');
  }
}


void showIpBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return FutureBuilder<String>(
        future: fetchIpAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container(
              height: 200,
              alignment: Alignment.center,
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi, size: 50, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    'Your IP Address is:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data!,
                    style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold ),
                  ),
                ],
              ),
            );
          }
        },
      );
    },
  );
}
