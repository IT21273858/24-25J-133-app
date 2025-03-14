import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final recorder = AudioRecorder();

  AudioRecorderService();

  String generateRandomFileName({String extension = 'wav'}) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomNumber = random.nextInt(100000); // Random 5-digit number
    return 'recording_$timestamp-$randomNumber.$extension';
  }

  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      // final applicationdir = await getApplicationDocumentsDirectory();
      final applicationdir = await getDownloadsDirectory();
      String genfilename = generateRandomFileName();
      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 16000),
        path: "${applicationdir?.path}/$genfilename",
      );
    }
  }

  Future<String?> stopRecording() async {
    return await recorder.stop();
  }
}
