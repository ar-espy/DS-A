import 'package:flutter/material.dart';
import 'name_input_screen.dart';

class OptimizationScreen extends StatefulWidget {
  final int numSuppliers;
  final int numConsumers;

  const OptimizationScreen({super.key, required this.numSuppliers, required this.numConsumers});

  @override
  // ignore: library_private_types_in_public_api
  _OptimizationScreenState createState() => _OptimizationScreenState();
}

class _OptimizationScreenState extends State<OptimizationScreen> {
  List<TextEditingController> supplyControllers = [];
  List<TextEditingController> demandControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    supplyControllers = List.generate(widget.numSuppliers, (_) => TextEditingController());
    demandControllers = List.generate(widget.numConsumers, (_) => TextEditingController());
  }

  void _submitData() {
    List<double> supply = supplyControllers.map((controller) => double.parse(controller.text)).toList();
    List<double> demand = demandControllers.map((controller) => double.parse(controller.text)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameInputScreen(
          numSuppliers: widget.numSuppliers,
          numConsumers: widget.numConsumers,
          supply: supply,
          demand: demand,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Supply and Demand'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Supply Capacities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...supplyControllers.asMap().entries.map((entry) {
              int idx = entry.key;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(labelText: 'Supplier ${idx + 1} Capacity'),
                  keyboardType: TextInputType.number,
                ),
              );
            // ignore: unnecessary_to_list_in_spreads
            }).toList(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Demand Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...demandControllers.asMap().entries.map((entry) {
              int idx = entry.key;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(labelText: 'Consumer ${idx + 1} Demand'),
                  keyboardType: TextInputType.number,
                ),
              );
            // ignore: unnecessary_to_list_in_spreads
            }).toList(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitData,
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}