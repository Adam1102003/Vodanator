import 'dart:convert';
import 'package:http/http.dart' as http;

// A service class that handles API requests
class ApiService {
  // The URL endpoint for the login API
  final String loginUrl = 'http://192.168.28.249:8000/account/token/';

  // A method to perform the login request
  Future<String?> login(String email, String password) async {
    try {
      // Sending a POST request to the login URL with the provided email and password
      final response = await http.post(
        Uri.parse(loginUrl), // Parsing the login URL
        body: {
          'username': email, // Passing the email as the username in the request body
          'password': password, // Passing the password in the request body
        },
      );

      // Debugging: Print the response status code and body to the console
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // If the request is successful (status code 200), parse the response body
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body); // Decode the JSON response into a map
        return data['access']; // Return the access token from the response
      } else {
        // If the response status code is not 200, return null
        return null;
      }
    } catch (e) {
      // If an error occurs during the request, print the error and return null
      print('Error: $e');
      return null;
    }
  }
}
