import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pomodoro_voice_service.dart';

class PomodoroVoiceSettingsState {
  final bool voiceEnabled;
  final VoicePersona persona;
  final double volume;
  final double rate;
  final double pitch;
  final bool announceStart;
  final bool announceHalfway;
  final bool announceOneMinWarning;
  final bool announceCompletion;

  const PomodoroVoiceSettingsState({
    this.voiceEnabled = true,
    this.persona = VoicePersona.professional,
    this.volume = 1.0,
    this.rate = 0.50,
    this.pitch = 1.0,
    this.announceStart = true,
    this.announceHalfway = true,
    this.announceOneMinWarning = true,
    this.announceCompletion = true,
  });

  PomodoroVoiceSettingsState copyWith({
    bool? voiceEnabled,
    VoicePersona? persona,
    double? volume,
    double? rate,
    double? pitch,
    bool? announceStart,
    bool? announceHalfway,
    bool? announceOneMinWarning,
    bool? announceCompletion,
  }) {
    return PomodoroVoiceSettingsState(
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      persona: persona ?? this.persona,
      volume: volume ?? this.volume,
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
      announceStart: announceStart ?? this.announceStart,
      announceHalfway: announceHalfway ?? this.announceHalfway,
      announceOneMinWarning: announceOneMinWarning ?? this.announceOneMinWarning,
      announceCompletion: announceCompletion ?? this.announceCompletion,
    );
  }
}

class PomodoroVoiceSettingsNotifier extends StateNotifier<PomodoroVoiceSettingsState> {
  PomodoroVoiceSettingsNotifier() : super(const PomodoroVoiceSettingsState()) {
    _loadFromPrefs();
  }

  static const _kVoiceEnabled = 'pomodoro_voice_enabled';
  static const _kPersona = 'pomodoro_voice_persona';
  static const _kVolume = 'pomodoro_voice_volume';
  static const _kRate = 'pomodoro_voice_rate';
  static const _kPitch = 'pomodoro_voice_pitch';
  static const _kAnnounceStart = 'pomodoro_voice_announce_start';
  static const _kAnnounceHalfway = 'pomodoro_voice_announce_halfway';
  static const _kAnnounceOneMin = 'pomodoro_voice_announce_one_min';
  static const _kAnnounceCompletion = 'pomodoro_voice_announce_completion';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kVoiceEnabled) ?? true;
    final personaName = prefs.getString(_kPersona) ?? VoicePersona.professional.name;
    final volume = prefs.getDouble(_kVolume) ?? 1.0;
    final rate = prefs.getDouble(_kRate) ?? 0.50;
    final pitch = prefs.getDouble(_kPitch) ?? 1.0;
    final start = prefs.getBool(_kAnnounceStart) ?? true;
    final halfway = prefs.getBool(_kAnnounceHalfway) ?? true;
    final oneMin = prefs.getBool(_kAnnounceOneMin) ?? true;
    final completion = prefs.getBool(_kAnnounceCompletion) ?? true;

    final persona = VoicePersona.values.firstWhere(
      (p) => p.name == personaName,
      orElse: () => VoicePersona.professional,
    );

    state = PomodoroVoiceSettingsState(
      voiceEnabled: enabled,
      persona: persona,
      volume: volume,
      rate: rate,
      pitch: pitch,
      announceStart: start,
      announceHalfway: halfway,
      announceOneMinWarning: oneMin,
      announceCompletion: completion,
    );
  }

  Future<void> setVoiceEnabled(bool enabled) async {
    state = state.copyWith(voiceEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVoiceEnabled, enabled);
  }

  Future<void> setPersona(VoicePersona persona) async {
    state = state.copyWith(
      persona: persona,
      rate: persona.speechRate,
      pitch: persona.pitch,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPersona, persona.name);
    await prefs.setDouble(_kRate, persona.speechRate);
    await prefs.setDouble(_kPitch, persona.pitch);
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kVolume, volume);
  }

  Future<void> setRate(double rate) async {
    state = state.copyWith(rate: rate);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kRate, rate);
  }

  Future<void> setPitch(double pitch) async {
    state = state.copyWith(pitch: pitch);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPitch, pitch);
  }

  Future<void> setAnnounceStart(bool value) async {
    state = state.copyWith(announceStart: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAnnounceStart, value);
  }

  Future<void> setAnnounceHalfway(bool value) async {
    state = state.copyWith(announceHalfway: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAnnounceHalfway, value);
  }

  Future<void> setAnnounceOneMinWarning(bool value) async {
    state = state.copyWith(announceOneMinWarning: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAnnounceOneMin, value);
  }

  Future<void> setAnnounceCompletion(bool value) async {
    state = state.copyWith(announceCompletion: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAnnounceCompletion, value);
  }
}

final pomodoroVoiceSettingsProvider =
    StateNotifierProvider<PomodoroVoiceSettingsNotifier, PomodoroVoiceSettingsState>((ref) {
  return PomodoroVoiceSettingsNotifier();
});
