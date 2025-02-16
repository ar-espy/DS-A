import 'package:flutter/material.dart';
import 'external_factors_screen.dart';

class CostMatrixScreen extends StatefulWidget {
  final int numSuppliers;
  final int numConsumers;
  final List<double> supply;
  final List<double> demand;
  final List<String> supplierNames;
  final List<String> consumerNames;

  const CostMatrixScreen({super.key, required this.numSuppliers, required this.numConsumers, required this.supply, required this.demand, required this.supplierNames, required this.consumerNames});

  @override
  // ignore: library_private_types_in_public_api
  _CostMatrixScreenState createState() => _CostMatrixScreenState();
}

class _CostMatrixScreenState extends State<CostMatrixScreen> {
  List<List<TextEditingController>> costControllers = [];

  @override
  void initState() {
    super.initState();
    costControllers = List.generate(widget.numSuppliers, (_) {
      return List.generate(widget.numConsumers, (_) => TextEditingController());
    });
  }

  void _submitCosts() {
    List<List<double>> costs = costControllers.map((row) {
      return row.map((controller) => double.parse(controller.text)).toList();
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExternalFactorsScreen(
          supply: widget.supply,
          demand: widget.demand,
          costs: costs,
          supplierNames: widget.supplierNames,
          consumerNames: widget.consumerNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Cost Matrix'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Cost Matrix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...costControllers.asMap().entries.map((supplierEntry) {
              int supplierIdx = supplierEntry.key;
              return Column(
                children: supplierEntry.value.asMap().entries.map((consumerEntry) {
                  int consumerIdx = consumerEntry.key;
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: TextField(
                      controller: consumerEntry.value,
                      decoration: InputDecoration(labelText: '${widget.supplierNames[supplierIdx]}-${widget.consumerNames[consumerIdx]}'),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
              );
            // ignore: unnecessary_to_list_in_spreads
            }).toList(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitCosts,
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}