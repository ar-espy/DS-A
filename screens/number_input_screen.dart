import 'package:flutter/material.dart';
import 'optimization_screen.dart';

class NumberInputScreen extends StatefulWidget {
  const NumberInputScreen({super.key});

  @override
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<NumberInputScreen> {
  TextEditingController supplierController = TextEditingController();
  TextEditingController consumerController = TextEditingController();

  void _submitNumbers() {
    int numSuppliers = int.parse(supplierController.text);
    int numConsumers = int.parse(consumerController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptimizationScreen(numSuppliers: numSuppliers, numConsumers: numConsumers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Numbers'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: supplierController,
              decoration: InputDecoration(labelText: 'Number of Suppliers'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: consumerController,
              decoration: InputDecoration(labelText: 'Number of Consumers'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitNumbers,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}