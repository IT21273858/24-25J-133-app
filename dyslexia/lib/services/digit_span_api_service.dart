import 'dart:convert';
import 'package:http/http.dart' as http;

class DigitSpanApiService {
  static const String flaskBaseUrl =
      "https://x4mf7d5w-5000.asse.devtunnels.ms/";
  static const String nodeBaseUrl = "https://x4mf7d5w-8000.asse.devtunnels.ms/";

  static Future<Map<String, dynamic>?> fetchDigitSequence({
    String difficulty = 'easy', // default value
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "$flaskBaseUrl/generate-digit-sequence?difficulty=$difficulty",
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching digit sequence: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> validateSequence(
    List<int> userSequence,
    List<int> originalSequence,
  ) async {
    try {
      print("object");
      final response = await http.post(
        Uri.parse(nodeBaseUrl + "digit-span-task/validate"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userSequence': userSequence,
          'originalSequence': originalSequence,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error validating sequence: $e");
    }
    return null;
  }
}
