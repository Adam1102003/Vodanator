import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Key for QR view
  Barcode? result; // Stores the scanned QR code result
  QRViewController? controller; // Controller for the QR view
  TextEditingController codeController = TextEditingController(); // Controller for manual serial number input
  String serialNumber = ""; // Stores the scanned or manually entered serial number
  String status = "Unavailable"; // Initial status of the product
  String site = ""; // Stores the site information associated with the product
  String details = ""; // Stores additional details about the product
  bool showCamera = false; // Flag to show or hide the camera view
  late AnimationController _animationController; // Controller for the animated line in the QR view

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repeats the animation in reverse
    _requestCameraPermission(); // Request camera permission at the start
  }

  Future<void> _requestCameraPermission() async {
    // Requests camera permission using the permission_handler package
    if (await Permission.camera.request().isGranted) {
      setState(() {}); // Updates UI if permission is granted
    } else {
      _showPermissionDeniedDialog(); // Shows a dialog if permission is denied
    }
  }

  void _showPermissionDeniedDialog() {
    // Displays a dialog when camera permission is denied
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text('Camera permission is required to scan QR codes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkSerialNumber(String serialNumber) async {
    // Sends an HTTP GET request to check the product details based on the serial number
    final response = await http.get(
      Uri.parse('https://adam8.pythonanywhere.com/myapi/products/get_product_by_serial/?serialNumber=$serialNumber'),
    );

    if (response.statusCode == 200) {
      // If the response is successful, parse and display the product details
      final data = json.decode(response.body);
      setState(() {
        status = data['status'] ? 'Available' : 'Unavailable';
        site = data['site'] ?? 'Not Available';
        details = data['details'] ?? 'No details available';
      });
      _showProductDetailsDialog(serialNumber, status, site, details); // Show the product details in a dialog
    } else {
      // Show an error message if the serial number is not found or an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serial number not found or an error occurred.')),
      );
    }
  }

  void _showProductDetailsDialog(String serialNumber, String status, String site, String details) {
    // Displays a dialog with product details
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded corners for the dialog
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Serial Number: $serialNumber',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Status: $status',
                style: TextStyle(
                  fontSize: 16,
                  color: status == 'Available' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Site ID: $site',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Details: $details',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Color.fromARGB(255, 230, 0, 0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void reassemble() {
    // Adjusts camera behavior based on platform when the widget is rebuilt
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Builds the UI for the scanner page
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFF7F7F7),
                Color(0xFFB3B3B3),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.asset("images/Vodafone-Symbol.png"), // Displays the Vodafone logo
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Center(
                  child: showCamera
                      ? _buildQrViewWithLine(context) // Builds the QR view with the animated line
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showCamera = true; // Shows the QR view when the button is pressed
                            });
                          },
                          child: Text('Scan Here'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 230, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 50,
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: codeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter Serial Number Manually',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final serialNumber = codeController.text;
                          _checkSerialNumber(serialNumber); // Checks the serial number manually entered
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 230, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 50,
                          ),
                        ),
                        child: Text(
                          'Show Product Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrViewWithLine(BuildContext context) {
    // Builds the QR view with a scanning line animation
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated, // Called when the QR view is created
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.35 * _animationController.value,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: child!,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 2,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // Sets up the QR view controller and listens for scanned data
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData; // Updates the scanned result
        serialNumber = result!.code!;
        codeController.text = serialNumber;
        _checkSerialNumber(serialNumber); // Checks the product details based on the scanned serial number
      });
    });
  }

  @override
  void dispose() {
    // Disposes of controllers when the widget is disposed
    controller?.dispose();
    codeController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
