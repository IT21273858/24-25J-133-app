import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dyslexia/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Checkpointtwo {
  static Future<Map<String, dynamic>?> fetchpara({int lines = 3}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/get-random-passage';

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

      print("Failed to Game Scores. Status code: ${response.statusCode}");

      return null;
    } catch (e) {
      print("Error in getScoresDetails: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifySpeak({
    String worddisplayed = "",
    String audiopath = "",
    String tTT = "",
    String averageWPM = "",
    String audioMeme = "",
    String readersId = "674c6844b809c21b9d948786",
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      String? role = prefs.getString('user_role');

      if (token == null || role == null) {
        print("User details not found in SharedPreferences");
        return null;
      }

      String url = '$pyserverurl/read/verify-passage';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "passage": worddisplayed,
          "audiopath": audiopath,
          "TTT": tTT,
          "AverageWPM": averageWPM,
          "audioMeme": audioMeme,
          "readersId": readersId,
        }),
      );

      if (response.statusCode == 200) {
        print("\n\n################ ✅ decoded & verfied audio");
        final resfinal = jsonDecode(response.body);
        print('✈️ output');
        print(resfinal);
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

  // now CPM
  static Future<Map<String, dynamic>?> calcWPM(
    String opath,
    String wordsDisplayed,
    String TTT,
    String AverageWPM,
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

      var audio = await http.MultipartFile.fromPath('audio', opath);

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
          worddisplayed: wordsDisplayed,
          audioMeme: audioMeme,
          audiopath: audiopath,
          averageWPM: AverageWPM,
          readersId: readersId,
          tTT: TTT,
        );

        if (verfiresult != null) {
          return verfiresult;
        }

        return null;
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
