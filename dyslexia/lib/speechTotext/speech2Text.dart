import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speecht2text {
  final SpeechToText _stt = SpeechToText();

  bool islistning = false;

  Future<bool> initSpeech({required VoidCallback onstoplisten}) async {
    bool initstatus = await _stt.initialize(
      onError: (errorNotification) => print("Error stoped $errorNotification"),
      onStatus: (status) {
        if (status == "notListening " || status == "done ") {
          islistning = false;
          onstoplisten();
        } else {
          islistning = true;
        }
      },
    );
    if (initstatus) {
      print("Speech (TTS) enabled ✅");
    } else {
      print(" Speech service disabled ❌");
    }

    return initstatus;
  }

  Future<void> listen({required SpeechResultListener onResult}) async {
    await _stt.listen(
      listenFor: Duration(minutes: 1),
      onResult: onResult,
      listenOptions: SpeechListenOptions(
        // autoPunctuation: true,
        partialResults: true,
      ),
    );
  }

  Future<void> stoplistening() async {
    await _stt.stop();
  }
}
