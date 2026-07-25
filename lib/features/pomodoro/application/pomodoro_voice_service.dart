import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum VoicePersona {
  calm('Calm Instructor', 0.45, 0.9),
  energetic('Energetic Coach', 0.55, 1.25),
  professional('Professional Assistant', 0.50, 1.0),
  gentle('Gentle Guide', 0.42, 0.85);

  final String label;
  final double speechRate;
  final double pitch;

  const VoicePersona(this.label, this.speechRate, this.pitch);
}

class PomodoroVoiceService {
  static final PomodoroVoiceService _instance = PomodoroVoiceService._internal();
  factory PomodoroVoiceService() => _instance;
  PomodoroVoiceService._internal();

  FlutterTts? _tts;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _tts = FlutterTts();
      await _tts?.setLanguage('en-US');
      await _tts?.setSpeechRate(0.5);
      await _tts?.setVolume(1.0);
      await _tts?.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing FlutterTts: $e');
    }
  }

  Future<void> speak(
    String text, {
    double volume = 1.0,
    double rate = 0.5,
    double pitch = 1.0,
  }) async {
    try {
      if (!_isInitialized) {
        await init();
      }
      await stop();
      await _tts?.setVolume(volume);
      await _tts?.setSpeechRate(rate);
      await _tts?.setPitch(pitch);
      await _tts?.speak(text);
    } catch (e) {
      debugPrint('Error in speak: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts?.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
