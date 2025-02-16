import 'package:flutter/material.dart';
import 'cost_matrix_screen.dart';

class NameInputScreen extends StatefulWidget {
  final int numSuppliers;
  final int numConsumers;
  final List<double> supply;
  final List<double> demand;

  const NameInputScreen({super.key, required this.numSuppliers, required this.numConsumers, required this.supply, required this.demand});

  @override
  // ignore: library_private_types_in_public_api
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  List<TextEditingController> supplierControllers = [];
  List<TextEditingController> consumerControllers = [];

  @override
  void initState() {
    super.initState();
    supplierControllers = List.generate(widget.numSuppliers, (_) => TextEditingController());
    consumerControllers = List.generate(widget.numConsumers, (_) => TextEditingController());
  }

  void _submitNames() {
    List<String> supplierNames = supplierControllers.map((controller) => controller.text).toList();
    List<String> consumerNames = consumerControllers.map((controller) => controller.text).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CostMatrixScreen(
          numSuppliers: widget.numSuppliers,
          numConsumers: widget.numConsumers,
          supply: widget.supply,
          demand: widget.demand,
          supplierNames: supplierNames,
          consumerNames: consumerNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Names'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter Supplier Names', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(widget.numSuppliers, (index) {
              return Padding(
                padding: EdgeInsets.all(4.0),
                child: TextField(
                  controller: supplierControllers[index],
                  decoration: InputDecoration(labelText: 'Supplier ${index + 1} Name'),
                ),
              );
            }),
            Text('Enter Consumer Names', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(widget.numConsumers, (index) {
              return Padding(
                padding: EdgeInsets.all(4.0),
                child: TextField(
                  controller: consumerControllers[index],
                  decoration: InputDecoration(labelText: 'Consumer ${index + 1} Name'),
                ),
              );
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitNames,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}