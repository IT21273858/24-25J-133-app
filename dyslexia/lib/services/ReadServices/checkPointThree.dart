import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dyslexia/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Checkpointthree {
  static Future<Map<String, dynamic>?> getWord({
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
        print("#################### ✅");
        print(response.body);
        return jsonDecode(response.body);
      }

      print(
        "Failed to fetch word for comph. Status code: ${response.statusCode}",
      );

      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getImages({
    String prompt = "Illstration of a cartoon rabbit",
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/gen/compAssment';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"word": prompt}),
      );

      if (response.statusCode == 200) {
        print("\n\n################ ✅ Images got ");
        final resfinal = jsonDecode(response.body);
        print('✈️ output');
        // print(resfinal);
        // print(resfinal['status']);
        return resfinal;
      }

      print(
        " Failed to verify audio:  status ${response.statusCode} , error : ${response.body}}",
      );

      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }
}
