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
}
