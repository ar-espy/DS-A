import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ResultsScreen({super.key, required this.data});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, dynamic>? results;

  @override
  void initState() {
    super.initState();
    _calculateResults();
  }

  void _calculateResults() async {
    var response = await http.post(
      Uri.parse('http://127.0.0.1:5000/optimize'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(widget.data),
    );

    if (response.statusCode == 200) {
      setState(() {
        results = jsonDecode(response.body);
      });
    } else {
      _showErrorDialog('Failed to calculate results.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: results == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9, // Make the card wider
                          padding: EdgeInsets.all(24.0), // Increase padding
                          child: Column(
                            children: [
                              Text('Status: ${results!['status']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text('Total Cost: ₹${results!['total_cost'].toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Text('Plan:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ...results!['plan'].entries.map((entry) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text('${entry.key}: ${entry.value.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                                );
                              }).toList(),
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