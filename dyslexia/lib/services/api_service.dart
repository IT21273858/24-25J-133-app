import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String parentBaseUrl =
      'https://btjcczvg-8000.asse.devtunnels.ms/parents';
  static const String childBaseUrl =
      'https://btjcczvg-8000.asse.devtunnels.ms/childrens';

  /// **Login Function**
  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    print("Income to login function");
    try {
      final parentResponse = await http.post(
        Uri.parse('$parentBaseUrl/login'),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      print("Parent response status: ${parentResponse.statusCode}");
      print("Parent response body: ${parentResponse.body}"); // Debugging

      if (parentResponse.statusCode == 200) {
        return await _handleLoginResponse(parentResponse.body, 'parent');
      }

      final childResponse = await http.post(
        Uri.parse('$childBaseUrl/login'),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      print("Child response status: ${childResponse.statusCode}");
      print("Child response body: ${childResponse.body}"); // Debugging

      if (childResponse.statusCode == 200) {
        return await _handleLoginResponse(childResponse.body, 'child');
      }

      print("Login failed: Invalid credentials");
      return null;
    } catch (e) {
      print("Error in loginUser: $e");
      return null;
    }
  }

  /// Handle login response and store user data

  static Future<Map<String, dynamic>?> _handleLoginResponse(
    String responseBody,
    String role,
  ) async {
    try {
      final responseData = jsonDecode(responseBody);

      // Extract the token
      final String token = responseData['token'] ?? '';
      if (token.isEmpty) {
        print("Invalid API response: Missing token");
        return null;
      }

      // Decode JWT token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract values safely
      final String userId = decodedToken['user']?.toString() ?? '';
      final String name = decodedToken['name'] ?? 'User';
      final String img = decodedToken['img'] ?? '';

      if (userId.isEmpty) {
        print("Invalid JWT Token: Missing user_id");
        return null;
      }

      // Save data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', userId); // Store user_id
      await prefs.setString('user_role', role);
      await prefs.setString('user_name', name);
      await prefs.setString('user_image', img);

      // Print for debugging
      print("=========== Decoded User Data ===========");
      print("Token: $token");
      print("Decoded User ID: $userId");
      print("Role: $role");
      print("Name: $name");
      print("Image URL: $img");
      print("====================================");

      return {
        "role": role,
        "token": token,
        "user_id": userId,
        "name": name,
        "img": img,
      };
    } catch (e) {
      print("Error in _handleLoginResponse: $e");
      return null;
    }
  }

  /// **Fetch user details**
  static Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url =
          role == 'parent'
              ? '$parentBaseUrl/auth/user'
              : '$childBaseUrl/auth/user';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print(
        "Failed to fetch user details. Status code: ${response.statusCode}",
      );
      return null;
    } catch (e) {
      print("Error in getUserDetails: $e");
      return null;
    }
  }

  /// **Logout Function**
  static Future<void> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print("User logged out successfully");
    } catch (e) {
      print("Error in logoutUser: $e");
    }
  }
}
