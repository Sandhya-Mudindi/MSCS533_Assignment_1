import 'package:flutter/material.dart';

void main() {
  // Run the main app
  runApp(const ConverterApp());
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the MaterialApp and set the home screen to ConversionScreen
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData(primarySwatch: Colors.blue), // Set app theme color
      home: ConversionScreen(), // Set ConversionScreen as the home screen
    );
  }
}

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  // Controller to manage the input text field
  final TextEditingController _controller = TextEditingController();

  double? _convertedValue; // Store the converted value
  String _fromUnit = 'meters'; // Default unit for 'from'
  String _toUnit = 'feet'; // Default unit for 'to'
  String? _errorMessage; // Error message if the conversion fails

  // A map of conversion rates between units
  final Map<String, double> _conversionRates = {
    'meters_feet': 3.28084,
    'feet_meters': 0.3048,
    'kilometers_miles': 0.621371,
    'miles_kilometers': 1.60934,
    'grams_pounds(lbs)': 0.00220462,
    'pounds(lbs)_grams': 453.592,
    'kilograms_pounds(lbs)': 2.20462,
    'pounds(lbs)_kilograms': 0.453592,
    'grams_ounces': 0.035274,
    'ounces_grams': 28.3495
  };

  // Function to handle conversion
  void _convert() {
    double inputValue = double.tryParse(_controller.text) ?? 0.0; // Parse the input value
    String key = '${_fromUnit}_$_toUnit'; // Create a key based on the 'from' and 'to' units

    setState(() {
      // Check if the conversion rate exists in the map
      if (_conversionRates.containsKey(key)) {
        // Perform the conversion and set the converted value
        _convertedValue = double.parse(
            (inputValue * _conversionRates[key]!).toStringAsFixed(4));
        _errorMessage = null; // Clear any error message
      } else {
        // If conversion rate doesn't exist, display error message
        _convertedValue = null;
        _errorMessage = 'Cannot convert $_fromUnit to $_toUnit';
      }
    });
  }

  // Function to update the "to" unit based on the selected "from" unit
  void _updateToUnit() {
    setState(() {
      // Update the "to" unit using the available units from the conversion map
      _toUnit = _conversionRates.keys
          .where((key) => key.startsWith("$_fromUnit")) // Filter keys that start with the "from" unit
          .map((key) => key.split('_')[1]) // Extract the "to" unit part of the key
          .firstOrNull ?? _toUnit; // Set the first available unit or keep the current "to" unit
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract unique units from conversionRates for the "to" unit options
    Set<String> availableUnits = _conversionRates.keys
        .where((key) => key.startsWith(_fromUnit)) // Filter keys that start with the "from" unit
        .map((key) => key.split('_')[1]) // Extract the "to" unit from the key
        .toSet(); // Convert the result into a set to get unique units

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the app bar color
        title: Text('Measures Converter', style: TextStyle(color: Colors.white)), // Set title color
        centerTitle: true, // Center the title
      ),
      backgroundColor: Colors.white, // Set the background color
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center-align the content
          children: [
            // Label and input field for the value
            Text("Value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controller, // Link the controller to the text field
              keyboardType: TextInputType.number, // Set the keyboard type for numeric input
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // Set background color for the input field
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Rounded borders
                hintText: "Enter value", // Placeholder text
              ),
            ),
            SizedBox(height: 20),
            
            // Label and drop-down for the "From" unit
            Text("From", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _fromUnit, // Current "from" unit
              isExpanded: true, // Make the drop-down take up all available space
              items: _conversionRates.keys
                  .map((key) => key.split('_')[0]) // Extract "from" units from keys
                  .toSet()
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit, style: TextStyle(color: Colors.blue)))) // Set drop-down text color to blue
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value!; // Update the selected "from" unit
                  _updateToUnit(); // Update the "to" unit based on the new "from" unit
                });
              },
            ),
            SizedBox(height: 20),
            
            // Label and drop-down for the "To" unit
            Text("To", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _toUnit, // Current "to" unit
              isExpanded: true, // Make the drop-down take up all available space
              items: availableUnits
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit, style: TextStyle(color: Colors.blue)))) // Set drop-down text color to blue
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value!; // Update the selected "to" unit
                });
              },
            ),
            SizedBox(height: 20),
            
            // Convert button
            ElevatedButton(
              onPressed: _convert, // Call the convert function on button press
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the button color
                foregroundColor: Colors.white, // Set the text color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Set padding
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
              ),
              child: Text("Convert"), // Button label
            ),
            SizedBox(height: 20),
            
            // Display error message if any, or the converted result
            if (_errorMessage != null)
              Text(_errorMessage!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            if (_convertedValue != null)
              Text("${_controller.text} $_fromUnit are $_convertedValue $_toUnit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
