import 'package:flutter/material.dart';
import 'api_service.dart';
import 'widgets/custom_text_form.dart';

// The LoginPage widget, which provides a user interface for logging in
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// The state class for LoginPage, managing the form's state and login logic
class _LoginPageState extends State<LoginPage> {
  // Controllers for the email and password input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Instance of ApiService to handle API requests
  final ApiService _apiService = ApiService();
  
  // Key to manage the form state and enable validation
  final _formKey = GlobalKey<FormState>();

  // Function to handle the login process
  void _login() async {
    // Validate the form fields before making the login request
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Attempt to log in with the provided email and password
        final token = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );
        // If login is successful and a token is received, navigate to the scanner page
        if (token != null) {
          Navigator.pushReplacementNamed(context, '/scanner');
        }
      } catch (e) {
        // If an error occurs, print the error and show a snack bar with the error message
        print('Login failed: $e');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // Set the width and height of the container to match the screen size
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          // Apply a linear gradient background to the container
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Color.fromARGB(255, 100, 97, 97),
              ],
            ),
          ),
          child: Column(
            children: [
              // Top-left aligned Vodafone logo
              Container(
                alignment: Alignment.topLeft,
                child: const SizedBox(
                  width: 70,
                  height: 70,
                  child: Image(
                    image: AssetImage("images/Vodafone-Symbol.png"),
                  ),
                ),
              ),
              // SizedBox for spacing and containing the form elements
              const SizedBox(
                height: 400,
                width: 300,
                child: Stack(
                  children: [
                    // Positioned "Login" text at the top of the form
                    Positioned(
                      top: 60,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Custom form widget that contains the email, password fields, and submit button
                    MyCustomForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
