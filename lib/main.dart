import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CostOptimizerApp());
}

class CostOptimizerApp extends StatefulWidget {
  const CostOptimizerApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CostOptimizerAppState createState() => _CostOptimizerAppState();
}

class _CostOptimizerAppState extends State<CostOptimizerApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cost Optimizer App',
      theme: _isDarkTheme ? _darkTheme : _lightTheme,
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}

final ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  hintColor: Colors.orange,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: AppBarTheme(
    color: Colors.teal,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey,
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: Colors.teal, // Button text color
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    labelStyle: TextStyle(color: Colors.teal),
    prefixIconColor: Colors.teal,
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.teal,
    selectionColor: Colors.teal.withOpacity(0.5),
    selectionHandleColor: Colors.teal,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(color: Colors.teal),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  hintColor: Colors.orange,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    color: Colors.teal,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[800],
    shadowColor: Colors.black,
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: Colors.teal, // Button text color
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    labelStyle: TextStyle(color: Colors.teal),
    prefixIconColor: Colors.teal,
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.teal,
    selectionColor: Colors.teal.withOpacity(0.5),
    selectionHandleColor: Colors.teal,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(color: Colors.teal),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
    ),
  ),
);
