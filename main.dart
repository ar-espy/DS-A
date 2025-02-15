import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CostOptimizerApp());
}

class CostOptimizerApp extends StatelessWidget {
  const CostOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cost Optimizer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
