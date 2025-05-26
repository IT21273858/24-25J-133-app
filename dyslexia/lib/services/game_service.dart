import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class GameService {
  static const String parentBaseUrl =
      'https://57qld95f-8000.asse.devtunnels.ms/parents';
  static const String childBaseUrl =
      'https://57qld95f-8000.asse.devtunnels.ms/childrens';
  static const String baseUrl = 'https://57qld95f-8000.asse.devtunnels.ms';

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

  static Future<Map<String, dynamic>?> generateShape(String level) async {
    print("Income to generate shapes function");
    try {
      final shapeResponse = await http.post(
        Uri.parse('$baseUrl/predict-pattern'),
        body: jsonEncode({"difficulty": level}),
        headers: {"Content-Type": "application/json"},
      );

      print("Shape response status: ${shapeResponse.statusCode}");
      print("Shape response body: ${shapeResponse.body}"); // Debugging

      if (shapeResponse.statusCode == 200) {
        final responseData = jsonDecode(shapeResponse.body);
        print("####(((())))");
        print(responseData);
        return responseData; // Returns {status: true, patternPrediction: {...}}
      }
    } catch (e) {
      print("Error in Getting Shapes: $e");
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> generateShapes(String level) async {
    print("Income to generate shapes function");
    try {
      final shapeResponse = await http.post(
        Uri.parse('$baseUrl/generate-shapes'),
        body: jsonEncode({"difficulty": level}),
        headers: {"Content-Type": "application/json"},
      );

      print("Shape response status: ${shapeResponse.statusCode}");
      print("Shape response body: ${shapeResponse.body}"); // Debugging

      if (shapeResponse.statusCode == 200) {
        final responseData = jsonDecode(shapeResponse.body);
        print("####(((())))");
        print(responseData);
        return responseData; // Returns {status: true, patternPrediction: {...}}
      }
    } catch (e) {
      print("Error in Getting Shapes: $e");
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getAllGames() async {
    print("Income to get all games function");
    try {
      final gameResponse = await http.get(
        Uri.parse('$baseUrl/games/getAll'),
        headers: {"Content-Type": "application/json"},
      );

      print("Shape response status: ${gameResponse.statusCode}");
      print("Shape response body: ${gameResponse.body}"); // Debugging

      if (gameResponse.statusCode == 200) {
        final responseData = jsonDecode(gameResponse.body);
        print("####(((())))");
        print(responseData);
        return responseData; // Returns {status: true, patternPrediction: {...}}
      }
    } catch (e) {
      print("Error in Getting Games: $e");
      return null;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> predictDrawnShape(File file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print("User authentication token not found");
        return null;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict-new-shape'),
      );
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse('$baseUrl/predict-shape'),
      // );

      request.headers["Authorization"] = "Bearer $token";
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        print("✅ Shape Predicted: ${decodedResponse['prediction']}");
        return decodedResponse;
      } else {
        print("❌ Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error sending file: $e");
    }
    return null;
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

  static Future<String?> generateGANShape(String label) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate-gan-shape'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'label': label}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['image_base64']; // Get base64 image string
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error generating GAN shape: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getGANShape(String shapeName) async {
    try {
      print("Fetching GAN shape image for: $shapeName");

      final response = await http.post(
        Uri.parse('$baseUrl/get-gan-shape'),
        body: jsonEncode({"shape": shapeName}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ GAN shape response: $responseData");
        return responseData; // Expected to return {"image_base64": "..."}
      } else {
        print("❌ GAN shape API error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in getGANShape: $e");
      return null;
    }
  }
}
