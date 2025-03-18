import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dyslexia/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Checkpointone {
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

      String url = '$pyserverurl/read/gen/word';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"difficulty": difflevl}),
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

  static Future<bool> verifySpeak({
    String audiopath = "",
    String audioMeme = "",
    String worddisplayed = "",
    String difficulty = "Easy",
    String readersId = "674c6844b809c21b9d948786",
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return false;
      }

      String url = '$serverurl/read/phonemes/verify';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "audiopath": audiopath,
          "audioMeme": audioMeme,
          "worddisplayed": worddisplayed,
          "difficulty": difficulty,
          "readersId": readersId,
        }),
      );

      if (response.statusCode == 200) {
        print("\n\n################ ✅ decoded & verfied audio");
        final resfinal = jsonDecode(response.body);
        print(resfinal);
        print('✈️ status');
        print(resfinal['status']);
        return resfinal['status'];
      }

      print(
        " Failed to verify audio:  status ${response.statusCode} , error : ${response.body}}",
      );

      return false;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getTextfromSpeech(
    String path,
    String displayword,
    String difflevel,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');
      String? uid = prefs.getString('user_id');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return {"result": false};
      }

      String url = '$serverurl/read/upload-audio';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      var audio = await http.MultipartFile.fromPath('audio', path);

      request.files.add(audio);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final jresponse = jsonDecode(responseBody);
        print("######### ✅ uploaded audio\n");
        print(jresponse);
        final audiopath = jresponse['file']['path'];
        final audioMeme = "audio/mpeg";
        final memetype = jresponse['file']['mimetype'];

        final readersId = "674c6844b809c21b9d948786";

        final verfiresult = await verifySpeak(
          audioMeme: audioMeme,
          audiopath: audiopath,
          difficulty: difflevel,
          readersId: readersId,
          worddisplayed: displayword,
        );

        if (verfiresult) {
          return {"result": true};
        }

        return {"result": false};
      }

      final error = await response.stream.bytesToString();
      print(
        " 👎 ❌ Failed to verify getTextspeech:  status ${response.statusCode} , error : ${error}}",
      );
      return {"result": false};
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return {"result": false};
    }
  }
}
