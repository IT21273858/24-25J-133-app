import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MemoryService {
  static const String parentBaseUrl =
      'https://x4mf7d5w-8000.asse.devtunnels.ms/parents';
  static const String childBaseUrl =
      'https://x4mf7d5w-8000.asse.devtunnels.ms/childrens';
  static const String baseUrl = 'https://x4mf7d5w-8000.asse.devtunnels.ms/';

  static Future<Map<String, dynamic>?> generateDigitSequence() async {
    print("🔄 Fetching digit sequence...");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/generate-digit-sequence'),
        headers: {"Content-Type": "application/json"},
      );

      print("📩 Response Status: ${response.statusCode}");
      print("📜 Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Digit Sequence Received:");
        print(responseData);
        return responseData; // Expected format: {status: true, digitSequence: {...}, message: "..."}
      } else {
        print("❌ Failed to fetch digit sequence: ${response.statusCode}");
        return {"status": false, "message": "Failed to fetch digit sequence"};
      }
    } catch (e) {
      print("⚠️ Error in generateDigitSequence: $e");
      return {"status": false, "message": "An error occurred"};
    }
  }

  static Future<Map<String, dynamic>?> identifyShape() async {
    print("🔄 Fetching identified shape...");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/identify-shape'),
        headers: {"Content-Type": "application/json"},
      );

      print("📩 Response Status: ${response.statusCode}");
      print("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Shape Identified Successfully:");
        print(responseData);
        return responseData;
      } else {
        print("❌ Failed to fetch shape: ${response.statusCode}");
        return {"status": false, "message": "Failed to identify shape"};
      }
    } catch (e) {
      print("⚠️ Error in identifyShape: $e");
      return {"status": false, "message": "An error occurred"};
    }
  }

  static Future<Map<String, dynamic>?> generateWord() async {
    print("🔄 Fetching generated word...");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/generate-word'),
        headers: {"Content-Type": "application/json"},
      );

      print("📩 Response Status: ${response.statusCode}");
      print("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Word Generated Successfully:");
        print(responseData);
        return responseData; // Expected format: {status: true, generatedWord: {...}, message: "Word generated successfully."}
      } else {
        print("❌ Failed to fetch word: ${response.statusCode}");
        return {"status": false, "message": "Failed to generate word"};
      }
    } catch (e) {
      print("⚠️ Error in generateWord: $e");
      return {"status": false, "message": "An error occurred"};
    }
  }

  static Future<Map<String, dynamic>?> getScoresDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$baseUrl/gamescore/getAll';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print("####################");
        print(response.body);
        return jsonDecode(response.body);
      }

      print("Failed to Game Scores. Status code: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getScoresDetailsChild() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');
      String? uid = prefs.getString('user_id');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$baseUrl/gamescore/getbychildren/${uid}';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print("####################");
        print(response.body);
        return jsonDecode(response.body);
      }

      print("Failed to Game Scores. Status code: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }

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

  static Future<Map<String, dynamic>?> verifyGame(
    Map<String, dynamic> data,
  ) async {
    print("🔄 Sending game verification request...");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/games/verify-gamecompletion'),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include token if required
        },
      );

      print("📩 Response Status: ${response.statusCode}");
      print("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Game Verification Success:");
        print(responseData);
        return responseData;
      } else {
        print("❌ Game Verification Failed: ${response.statusCode}");
        return {"status": false, "message": "Failed to verify game"};
      }
    } catch (e) {
      print("⚠️ Error in verifyGame: $e");
      return {"status": false, "message": "An error occurred"};
    }
  }
}
