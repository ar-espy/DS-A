import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sankey_painter.dart';
import 'dart:math';

class ResultsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ResultsScreen({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, dynamic>? results;
  final Map<String, Color> linkColors = {};

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

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
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
                              _buildTable(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9, // Make the card wider
                          padding: EdgeInsets.all(24.0), // Increase padding
                          child: _buildSankeyDiagram(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Supplier to Consumer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ...results!['plan'].entries.map((entry) {
          return TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(entry.key),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(entry.value.toStringAsFixed(2)),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSankeyDiagram() {
    List<SankeyNode> nodes = [];
    List<SankeyLink> links = [];

    // Create nodes and links based on the results
    results!['plan'].forEach((key, value) {
      if (value == 0.0) return; // Skip links with 0.00 values

      var parts = key.split(' to ');
      var supplier = parts[0];
      var consumer = parts[1];

      var supplierNode = nodes.firstWhere((node) => node.label == supplier, orElse: () {
        var node = SankeyNode(x: nodes.length * 150.0, y: 50, width: 100, height: 50, label: supplier);
        nodes.add(node);
        return node;
      });

      var consumerNode = nodes.firstWhere((node) => node.label == consumer, orElse: () {
        var node = SankeyNode(x: nodes.length * 150.0, y: 300, width: 100, height: 50, label: consumer);
        nodes.add(node);
        return node;
      });

      String linkLabel = '$supplier to $consumer';
      if (!linkColors.containsKey(linkLabel)) {
        linkColors[linkLabel] = _getRandomColor();
      }

      links.add(SankeyLink(source: supplierNode, target: consumerNode, value: value, label: linkLabel));
    });

    // Center the diagram
    double maxWidth = nodes.length * 150.0;
    double offsetX = (MediaQuery.of(context).size.width * 0.9 - maxWidth) / 2;
    for (var node in nodes) {
      node.x += offsetX;
    }

    return SizedBox(
      height: 400,
      child: CustomPaint(
        painter: SankeyPainter(nodes: nodes, links: links, linkColors: linkColors),
      ),
    );
  }
}