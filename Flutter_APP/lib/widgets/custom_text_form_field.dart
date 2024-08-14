import 'package:flutter/material.dart';

// CustomTextForm widget is a reusable text form field with customizable options
class CustomTextForm extends StatefulWidget {
  // Properties of the CustomTextForm widget
  final String labelText; // Label text for the form field
  final bool isObscure; // Whether the text should be obscured (e.g., for passwords)
  final Widget? suffixIcon; // Optional suffix icon (e.g., an eye icon for toggling obscured text)
  final TextEditingController? controller; // Optional text editing controller for the field

  // Constructor to initialize the CustomTextForm with required and optional parameters
  const CustomTextForm({
    super.key,
    required this.labelText, // Label text is required
    required this.isObscure, // Obscure flag is required
    this.suffixIcon, // Suffix icon is optional
    this.controller, // Controller is optional
  });

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

// State class for CustomTextForm
class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    // The TextFormField widget represents a form field for user input
    return TextFormField(
      controller: widget.controller, // Use the controller passed from the parent widget
      validator: (value) {
        // Validator checks if the field is empty
        if (value?.isEmpty ?? true) {
          return "This field is required"; // Returns an error message if the field is empty
        }
        return null; // No error if the field is not empty
      },
      obscureText: widget.isObscure, // Controls whether the text is obscured (e.g., for passwords)
      decoration: InputDecoration(
        labelText: widget.labelText, // Sets the label text of the field
        suffixIcon: widget.suffixIcon, // Adds an optional suffix icon
      ),
    );
  }
}
