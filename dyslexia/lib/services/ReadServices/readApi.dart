import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dyslexia/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Readapi {
  static Future<Map<String, dynamic>?> fetchWord({
    String difflevl = "Easy",
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/get-random-word';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
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

  static Future<Map<String, dynamic>?> fetchWordlist({
    String difflevl = "Easy",
    int limit = 10,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/gen/wlist';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"difficulty": difflevl, "limit": limit}),
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

  static Future<Map<String, dynamic>?> verifyHandwriting(String path) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');
      String? uid = prefs.getString('user_id');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/verify/handwriting';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      var image = await http.MultipartFile.fromPath('image', path);

      request.files.add(image);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        final jresponse = jsonDecode(responseBody);
        print("######### ✅ uploaded audio\n");
        print(jresponse);

        return jresponse;
      }

      final error = await response.stream.bytesToString();
      print(
        " 👎 ❌ Failed to verify Imagesendhandwrite:  status ${response.statusCode} , error : ${error}}",
      );
      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchWordWithMax({
    String difflevl = "Easy",
    int limit = 4,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/get-random-word-max';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"limit": limit}),
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
}
