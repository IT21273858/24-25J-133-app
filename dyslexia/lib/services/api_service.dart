import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ApiService {
  static const String parentBaseUrl =
      'https://57qld95f-8000.asse.devtunnels.ms/parents';
  static const String childBaseUrl =
      'https://57qld95f-8000.asse.devtunnels.ms/childrens';

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
      final String level = decodedToken['level'] ?? '';
      final String type = decodedToken['type'] ?? 'Reading';

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
      await prefs.setString('level', level);
      await prefs.setString('type', type);

      // Print for debugging
      print("^^^^^^^^^^^ Decoded User Data ^^^^^^^^^^^");
      print("Token: $token");
      print("Decoded User ID: $userId");
      print("Role: $role");
      print("Name: $name");
      print("Image URL: $img");
      print("Level: $level");
      print("Type: $type");
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

      // Fetch and store parent details
      await ApiService.fetchAndStoreParentDetails();

      return {
        "role": role,
        "token": token,
        "user_id": userId,
        "name": name,
        "img": img,
        "level": level,
        "type": type,
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

  // Fetch Parent Details Using user_id
  static Future<void> fetchAndStoreParentDetails() async {
    try {
      print("Income to fetch parent details");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      String? token = prefs.getString('auth_token');

      if (userId == null || token == null) {
        print("User ID or Token not found in local storage.");
        return;
      }

      String url = '$parentBaseUrl/get/$userId';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final parentData = jsonDecode(response.body);

        // Store data in SharedPreferences
        print("**************");
        print(parentData);
        await prefs.setString('parent_name', parentData['parent']['name']);
        await prefs.setString('parent_email', parentData['parent']['email']);
        await prefs.setString(
          'parent_image',
          parentData['parent']['profile_img'],
        );
        await prefs.setString(
          'parent_phone',
          parentData['parent']['phoneNumber'],
        );
        await prefs.setString(
          'parent_address',
          parentData['parent']['address'],
        );
        // Fetch and Store Children Details
        List<dynamic> children = parentData['parent']['Children'] ?? [];
        await storeChildrenDetails(children);
        print("✅ Parent details fetched and stored successfully.");
      } else {
        print("⚠️ Failed to fetch parent details: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in fetchAndStoreParentDetails: $e");
    }
  }

  /// Store Children Details in SharedPreferences
  static Future<void> storeChildrenDetails(List<dynamic> children) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> childrenList = [];

      for (var child in children) {
        // Convert the `updatedAt` timestamp into a readable format
        String formattedDate = formatDateTime(child['updatedAt']);

        String childData = jsonEncode({
          "id": child['id'],
          "name": child['name'],
          "email": child['email'],
          "profile_img": child['profile_img'],
          "level": child['level'],
          "phone": child['phoneNumber'],
          "address": child['address'],
          "updatedAt": formattedDate, // Store formatted date
        });
        childrenList.add(childData);
      }

      await prefs.setStringList('children_list', childrenList);

      print("✅ Children details stored successfully.");
      print("Children List: $childrenList");
    } catch (e) {
      print("❌ Error in storeChildrenDetails: $e");
    }
  }

  // fetch and store child details Using user_id
  static Future<void> fetchAndStoreChildDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? childId = prefs.getString('user_id'); // Get stored child ID
      String? childId = prefs.getString('user_id');
      print("@@@@@@@@@@@@@@");
      print(childId);

      String? token = prefs.getString('auth_token');

      if (childId == null || token == null) {
        print("❌ Child ID or Token not found.");
        return;
      }

      String url = '$childBaseUrl/get/$childId';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final childData = jsonDecode(response.body);

        if (childData == null || childData['child'] == null) {
          print("❌ Invalid API response.");
          return;
        }

        // Store child details in SharedPreferences safely
        await prefs.setString(
          'child_name',
          childData['child']['name'] ?? "Unknown",
        );
        await prefs.setString(
          'child_email',
          childData['child']['email'] ?? "No Email",
        );
        await prefs.setString(
          'child_image',
          childData['child']['profile_img'] ?? "assets/images/user.png",
        );
        await prefs.setString(
          'child_address',
          childData['child']['address'] ?? "No Address",
        );
        await prefs.setString(
          'child_phone',
          childData['child']['phoneNumber'] ?? "No Phone",
        );
        await prefs.setString(
          'child_level',
          childData['child']['level'] ?? "N/A",
        );

        // Store game scores safely
        List<dynamic>? gameScores = childData['child']['GameScore'];
        print("***************");
        print(gameScores);
        if (gameScores != null && gameScores.isNotEmpty) {
          List<String> gameScoreList =
              gameScores.map((score) {
                return jsonEncode({
                  "name": score['name'] ?? "Unknown Game",
                  "score": score['score']?.toString() ?? "0",
                  "updatedAt": score['updatedAt'] ?? "N/A",
                });
              }).toList();

          await prefs.setStringList('game_scores', gameScoreList);
        }

        print("✅ Child details stored successfully.");
      } else {
        print("⚠️ Failed to fetch child details: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in fetchAndStoreChildDetails: $e");
    }
  }

  /// **Fetch Parent By ID Including Children**
  static Future<Map<String, dynamic>?> fetchParentById() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? parentId = prefs.getString('user_id'); // Get stored parent ID
      String? token = prefs.getString('auth_token'); // Get token for auth

      if (parentId == null || token == null) {
        print("❌ Parent ID or Token not found.");
        return null;
      }

      String url = '$parentBaseUrl/get/$parentId';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final parentData = jsonDecode(response.body);

        if (parentData == null || parentData['parent'] == null) {
          print("❌ Invalid API response.");
          return null;
        }

        // **Extract Parent Details**
        final parent = parentData['parent'];
        await prefs.setString('parent_name', parent['name'] ?? "Unknown");
        await prefs.setString('parent_email', parent['email'] ?? "No Email");
        await prefs.setString(
          'parent_image',
          parent['profile_img'] ?? "assets/images/user.png",
        );
        await prefs.setString(
          'parent_address',
          parent['address'] ?? "No Address",
        );
        await prefs.setString(
          'parent_phone',
          parent['phoneNumber'] ?? "No Phone",
        );

        // **Extract Children Details**
        List<dynamic>? children = parent['Children'];
        if (children != null && children.isNotEmpty) {
          List<String> childrenList =
              children.map((child) {
                return jsonEncode({
                  "id": child['id'],
                  "name": child['name'],
                  "email": child['email'],
                  "profile_img": child['profile_img'],
                  "level": child['level'],
                  "phone": child['phoneNumber'],
                  "address": child['address'],
                  "updatedAt": formatDateTime(
                    child['updatedAt'],
                  ), // Format timestamp
                });
              }).toList();

          await prefs.setStringList('children_list', childrenList);
        }

        print("✅ Parent & Children details stored successfully.");
        return parentData; // Return full parent details
      } else {
        print("⚠️ Failed to fetch parent details: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error in fetchParentById: $e");
      return null;
    }
  }

  /// **🔹 Helper Function: Convert Timestamp to "12 Feb 2024 - 12:30pm" Format**
  static String formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
      String formattedDate = DateFormat(
        "dd MMM yyyy - h:mm a",
      ).format(dateTime);
      return formattedDate;
    } catch (e) {
      print("❌ Error formatting date: $e");
      return "Invalid Date"; // Fallback in case of errors
    }
  }
}
