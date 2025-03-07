import 'package:flutter/material.dart';

void main() {
  runApp(const ConverterApp());
}

// Root Widget of the App
class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(primarySwatch: Colors.blue), // Sets theme color to blue
      home: ConversionScreen(), // Home screen of the app
    );
  }
}

// Stateful Widget to manage user inputs and conversions
class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _controller = TextEditingController(); // Controller for user input
  double _convertedValue = 0.0; // Stores the converted value
  String _fromUnit = 'meters'; // Default "From" unit
  String _toUnit = 'feet'; // Default "To" unit

  // Conversion rates between different units
  final Map<String, double> _conversionRates = {
    'meters_feet': 3.28084,
    'feet_meters': 0.3048,
    'kilometers_miles': 0.621371,
    'miles_kilometers': 1.60934,
    'grams_pounds': 0.00220462,
    'pounds_grams': 453.592,
  };

  // Function to perform the conversion
  void _convert() {
    double inputValue = double.tryParse(_controller.text) ?? 0.0; // Get the user input, default to 0 if invalid
    String key = '${_fromUnit}_$_toUnit'; // Create a key for lookup
    setState(() {
      _convertedValue = inputValue * (_conversionRates[key] ?? 1.0); // Perform conversion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Blue header background
        title: Text(
          'Measures Converter',
          style: TextStyle(color: Colors.white), // White text for the header
        ),
        centerTitle: true, // Center the title
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds spacing around elements
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label for "Value"
            Text(
              "Value",
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),

            // Input field for value entry
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number, // Accepts only numbers
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter value",
              ),
            ),

            SizedBox(height: 20), // Space between elements

            // Label for "From"
            Text(
              "From",
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),

            // Dropdown to select "From" unit
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              style: TextStyle(color: Colors.lightBlue), // Light blue text color
              dropdownColor: Colors.white, // White dropdown background
              items: _conversionRates.keys.map((key) => key.split('_')[0]).toSet().map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: TextStyle(color: Colors.lightBlue)), // Light blue text
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value!;
                });
              },
            ),

            SizedBox(height: 20), // Space between elements

            // Label for "To"
            Text(
              "To",
              style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),

            // Dropdown to select "To" unit
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              style: TextStyle(color: Colors.lightBlue), // Light blue text color
              dropdownColor: Colors.white, // White dropdown background
              items: _conversionRates.keys.map((key) => key.split('_')[1]).toSet().map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: TextStyle(color: Colors.lightBlue)), // Light blue text
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value!;
                });
              },
            ),

            SizedBox(height: 20), // Space between elements

            // Convert Button
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue button background
                foregroundColor: Colors.white, // White button text
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Button padding
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
              ),
              child: Text("Convert"), // Button text
            ),

            SizedBox(height: 20), // Space between elements

            // Display the converted result
            Text(
              "${_controller.text} $_fromUnit are $_convertedValue $_toUnit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
