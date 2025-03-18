import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DigitSpanService {
  static const String baseUrl = 'https://t5sgh4wr-8000.asse.devtunnels.ms';

  static Future<Map<String, dynamic>?> generateDigitSequence(
    int sequenceLength,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getDigitSpanTask?sequenceLength=$sequenceLength'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error generating digit sequence: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> validateDigitSequence(
    List<int> userSequence,
    List<int> originalSequence,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validateDigitSpanTask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userSequence': userSequence,
          'originalSequence': originalSequence,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error validating digit sequence: $e");
      return null;
    }
  }
}

class ShapeService {
  static const String baseUrl = 'https://t5sgh4wr-8000.asse.devtunnels.ms';

  static Future<Map<String, dynamic>?> identifyShape(
    String imagePath,
    int displayTime,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getIdentifyShape'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'imagePath': imagePath, 'displayTime': displayTime}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error identifying shape: $e");
      return null;
    }
  }
}

class WordService {
  static const String baseUrl = 'https://t5sgh4wr-8000.asse.devtunnels.ms';

  static Future<Map<String, dynamic>?> generateWord() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getGenerateWord'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Error generating word: $e");
      return null;
    }
  }
}
