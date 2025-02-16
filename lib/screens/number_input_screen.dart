import 'package:flutter/material.dart';
import 'optimization_screen.dart';

class NumberInputScreen extends StatefulWidget {
  const NumberInputScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<NumberInputScreen> {
  final _supplierController = TextEditingController();
  final _consumerController = TextEditingController();

  void _submitNumbers() {
    int numSuppliers = int.parse(_supplierController.text);
    int numConsumers = int.parse(_consumerController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptimizationScreen(
          numSuppliers: numSuppliers,
          numConsumers: numConsumers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _supplierController,
              decoration: InputDecoration(
                labelText: 'Number of Suppliers',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _consumerController,
              decoration: InputDecoration(
                labelText: 'Number of Consumers',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40),
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