import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class GameService {
  static const String parentBaseUrl =
      'https://btjcczvg-8000.asse.devtunnels.ms/parents';
  static const String childBaseUrl =
      'https://btjcczvg-8000.asse.devtunnels.ms/childrens';
  static const String baseUrl = 'https://btjcczvg-8000.asse.devtunnels.ms';

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
}
