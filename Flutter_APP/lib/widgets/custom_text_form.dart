import 'package:flutter/material.dart';
import 'custom_elevated_button.dart';
import 'custom_text_form.dart';
import 'custom_text_form_field.dart';

// The main form widget which uses custom text fields and a custom button
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Key to identify the form and enable validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to manage the input for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Boolean to toggle password visibility
  bool _obscureText = true;

  // Function to toggle the obscure text flag, updating the UI accordingly
  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8), // Padding around the form
      child: Form(
        key: _formKey, // Assigning the form key to the Form widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom email input field
            CustomTextForm(
              controller: _emailController, // Controller for the email field
              labelText: "NT Account", // Label text for the email field
              isObscure: false, // Email should not be obscured
              suffixIcon: null, // No suffix icon for email field
            ),
            const SizedBox(
              height: 10, // Spacing between email and password fields
            ),
            // Custom password input field
            CustomTextForm(
              controller: _passwordController, // Controller for the password field
              labelText: "Password", // Label text for the password field
              isObscure: _obscureText, // Obscure text based on _obscureText flag
              suffixIcon: IconButton( // Icon button to toggle password visibility
                onPressed: togglePasswordVisibility, // Toggle visibility on press
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off, // Icon changes based on _obscureText flag
                ),
              ),
            ),
            const SizedBox(height: 24), // Spacing before the submit button
            // Custom elevated button for form submission
            CustomElevatedButton(
              formKey: _formKey, // Passing the form key to the button
              emailController: _emailController, // Passing the email controller to the button
              passwordController: _passwordController, // Passing the password controller to the button
            ),
          ],
        ),
      ),
    );
  }
}
