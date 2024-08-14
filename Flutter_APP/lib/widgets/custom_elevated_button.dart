import 'package:flutter/material.dart';
import '../api_service.dart';
import '../scanner.dart';

// A custom elevated button widget that handles form validation and login logic
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey, 
        _emailController = emailController, 
        _passwordController = passwordController;

  // These are the form key and controllers passed from the parent widget
  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    // Initialize the API service for making login requests
    final ApiService _apiService = ApiService();

    return ElevatedButton(
      // Action to be performed when the button is pressed
      onPressed: () async {
        // Check if the form is valid before proceeding
        if (_formKey.currentState!.validate()) {
          try {
            // Attempt to log in with the provided email and password
            final token = await _apiService.login(
              _emailController.text,
              _passwordController.text,
            );
            print('Token: $token'); // Debugging: Print the received token
            
            // If the token is received, navigate to the ScannerPage
            if (token != null) {
              print('Navigating to ScannerPage...');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScannerPage()),
              );
            } else {
              // If the login fails (no token), show an error message
              print('Invalid email or password');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid email or password!')),
              );
            }
          } catch (e) {
            // Handle any errors that occur during login
            print('Login failed: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        // Save the form state (for further processing if needed)
        _formKey.currentState!.save();
      },
      // Styling the button with a custom background color
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 58, 57, 57)),
      ),
      // Button label
      child: const Text(
        style: TextStyle(color: Colors.white), // Set the text color to white
        'Submit',
      ),
    );
  }
}
