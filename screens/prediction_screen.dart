import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionScreen extends StatefulWidget {
  final double optimizedCost;

  const PredictionScreen({super.key, required this.optimizedCost});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedWeather = 'Sunny';
  String selectedWeekDay = 'Monday';

  List<String> weatherOptions = ['Sunny', 'Rainy', 'Cloudy'];
  List<String> weekDayOptions = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submitData() async {
    print('Submit button pressed'); // Debug print

    int hour = selectedTime.hour;

    var data = {
      'TimeOfDay': hour,
      'Weather': selectedWeather,
      'WeekDay': selectedWeekDay,
      'optimized_cost': widget.optimizedCost,
    };

    print('Sending data: $data'); // Debug print

    // Send POST request to backend
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print('Response status: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print('Prediction result: $result'); // Debug print
      _showResultDialog(result['predicted_cost'], result['optimized_cost'], result['cost_difference']);
    } else {
      _showErrorDialog('Failed to predict cost.');
    }
  }

  void _showResultDialog(double predictedCost, double optimizedCost, double costDifference) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Predicted Cost'),
          content: Text(
            'Optimized Cost: \$${optimizedCost.toStringAsFixed(2)}\n'
            'Predicted Cost: \$${predictedCost.toStringAsFixed(2)}\n'
            'Cost Difference: \$${costDifference.toStringAsFixed(2)}',
          ),
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

  // Build the UI for input fields
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Time Picker
            ListTile(
              title: Text('Select Time of Day'),
              subtitle: Text(selectedTime.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 16.0),
            // Weather Dropdown
            DropdownButtonFormField<String>(
              value: selectedWeather,
              decoration: InputDecoration(labelText: 'Weather Forecast'),
              items: weatherOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedWeather = newValue!;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Weekday Dropdown
            DropdownButtonFormField<String>(
              value: selectedWeekDay,
              decoration: InputDecoration(labelText: 'Day of the Week'),
              items: weekDayOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedWeekDay = newValue!;
                });
              },
            ),
            SizedBox(height: 32.0),
            // Submit Button
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Predict Cost'),
            ),
          ],
        ),
      ),
    );
  }
}