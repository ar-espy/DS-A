import 'package:flutter/material.dart';
import 'results_screen.dart';

class ExternalFactorsScreen extends StatefulWidget {
  final List<double> supply;
  final List<double> demand;
  final List<List<double>> costs;
  final List<String> supplierNames;
  final List<String> consumerNames;

  const ExternalFactorsScreen({super.key, required this.supply, required this.demand, required this.costs, required this.supplierNames, required this.consumerNames});

  @override
  // ignore: library_private_types_in_public_api
  _ExternalFactorsScreenState createState() => _ExternalFactorsScreenState();
}

class _ExternalFactorsScreenState extends State<ExternalFactorsScreen> {
  List<List<String>> selectedWeather = [];
  List<List<String>> selectedTime = [];
  List<List<String>> selectedDay = [];

  List<String> weatherOptions = ['Sunny', 'Rainy', 'Cloudy', 'Heavy Rain', 'Light Rain', 'Moderate Rain', 'Mostly Cloudy', 'Partly Cloudy', 'Thunderstorms', 'Windy', 'Fog', 'Hail', 'Light Snow', 'Moderate Snow', 'Heavy Snow'];
  List<String> timeOptions = ['Morning Rush Hour', 'Afternoon', 'Evening Rush Hour', 'Midday', 'Night'];
  List<String> dayOptions = ['Holiday', 'Weekday', 'Weekend'];

  @override
  void initState() {
    super.initState();
    _initializeSelections();
  }

  void _initializeSelections() {
    selectedWeather = List.generate(widget.supply.length, (_) {
      return List.generate(widget.demand.length, (_) => weatherOptions[0]);
    });
    selectedTime = List.generate(widget.supply.length, (_) {
      return List.generate(widget.demand.length, (_) => timeOptions[0]);
    });
    selectedDay = List.generate(widget.supply.length, (_) {
      return List.generate(widget.demand.length, (_) => dayOptions[0]);
    });
  }

  void _submitData() {
    var data = {
      'supply': widget.supply,
      'demand': widget.demand,
      'costs': widget.costs,
      'weatherFactors': selectedWeather,
      'timeFactors': selectedTime,
      'dayFactors': selectedDay,
      'supplierNames': widget.supplierNames,
      'consumerNames': widget.consumerNames,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter External Factors'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('External Factors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...selectedWeather.asMap().entries.map((supplierEntry) {
              int supplierIdx = supplierEntry.key;
              return Column(
                children: supplierEntry.value.asMap().entries.map((consumerEntry) {
                  int consumerIdx = consumerEntry.key;
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedWeather[supplierIdx][consumerIdx],
                            decoration: InputDecoration(labelText: 'Weather ${widget.supplierNames[supplierIdx]}-${widget.consumerNames[consumerIdx]}'),
                            items: weatherOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedWeather[supplierIdx][consumerIdx] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedTime[supplierIdx][consumerIdx],
                            decoration: InputDecoration(labelText: 'Time ${widget.supplierNames[supplierIdx]}-${widget.consumerNames[consumerIdx]}'),
                            items: timeOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedTime[supplierIdx][consumerIdx] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedDay[supplierIdx][consumerIdx],
                            decoration: InputDecoration(labelText: 'Day ${widget.supplierNames[supplierIdx]}-${widget.consumerNames[consumerIdx]}'),
                            items: dayOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDay[supplierIdx][consumerIdx] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
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