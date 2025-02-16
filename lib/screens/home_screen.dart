import 'package:flutter/material.dart';
import 'number_input_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Optimizer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Cost Optimizer!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'This application helps you optimize costs by calculating the most efficient distribution of resources between suppliers and consumers. To get started, please click the button below and enter the required details.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NumberInputScreen()),
                  );
                },
                child: Text('Start Optimization'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}