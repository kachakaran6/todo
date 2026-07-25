import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/features/pomodoro/application/pomodoro_voice_provider.dart';
import 'package:orbit_todo/features/pomodoro/application/pomodoro_voice_service.dart';
import 'package:orbit_todo/features/pomodoro/presentation/widgets/pomodoro_voice_settings_sheet.dart';

/// Pomodoro Focus Timer with Voice Guidance and Ambient White Noise.
class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  int _selectedModeIndex = 0; // 0=Pomodoro (25m), 1=Short Break (5m), 2=Long Break (15m), 3=Stopwatch
  late int _remainingSeconds;
  late int _totalDurationSeconds;
  bool _isRunning = false;
  Timer? _timer;
  String _selectedSound = 'None';

  final List<Map<String, dynamic>> _modes = [
    {'name': 'Pomodoro', 'seconds': 25 * 60},
    {'name': 'Short Break', 'seconds': 5 * 60},
    {'name': 'Long Break', 'seconds': 15 * 60},
    {'name': 'Stopwatch', 'seconds': 0},
  ];

  final List<Map<String, dynamic>> _sounds = [
    {'name': 'None', 'icon': Icons.music_off_rounded},
    {'name': 'Clock', 'icon': Icons.access_time_rounded},
    {'name': 'Boiling', 'icon': Icons.soup_kitchen_rounded},
    {'name': 'Wooden fish', 'icon': Icons.set_meal_rounded},
    {'name': 'Rain', 'icon': Icons.water_drop_rounded},
    {'name': 'Cafe', 'icon': Icons.local_cafe_rounded},
    {'name': 'Morning', 'icon': Icons.wb_sunny_rounded},
    {'name': 'Summer', 'icon': Icons.nature_people_rounded},
    {'name': 'Forest', 'icon': Icons.park_rounded},
    {'name': 'Stream', 'icon': Icons.waves_rounded},
    {'name': 'Wave', 'icon': Icons.sailing_rounded},
    {'name': 'Desert', 'icon': Icons.landscape_rounded},
    {'name': 'Street', 'icon': Icons.location_city_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _totalDurationSeconds = _modes[_selectedModeIndex]['seconds'] as int;
      _remainingSeconds = _totalDurationSeconds;
    });
  }

  void _speakEvent(String type) {
    final voiceState = ref.read(pomodoroVoiceSettingsProvider);
    if (!voiceState.voiceEnabled) return;

    final modeName = _modes[_selectedModeIndex]['name'] as String;
    String text = '';

    switch (type) {
      case 'start':
        if (voiceState.announceStart) {
          text = '$modeName started. Stay focused!';
        }
        break;
      case 'pause':
        text = 'Timer paused.';
        break;
      case 'halfway':
        if (voiceState.announceHalfway) {
          text = 'Halfway done! Keep up the great work.';
        }
        break;
      case 'one_min':
        if (voiceState.announceOneMinWarning) {
          text = 'One minute remaining.';
        }
        break;
      case 'complete':
        if (voiceState.announceCompletion) {
          text = '$modeName completed. Great job!';
        }
        break;
    }

    if (text.isNotEmpty) {
      PomodoroVoiceService().speak(
        text,
        volume: voiceState.volume,
        rate: voiceState.rate,
        pitch: voiceState.pitch,
      );
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      _speakEvent('pause');
    } else {
      setState(() => _isRunning = true);
      _speakEvent('start');
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_selectedModeIndex == 3) {
          // Stopwatch mode counts up
          setState(() => _remainingSeconds++);
        } else {
          // Countdown modes
          if (_remainingSeconds > 0) {
            setState(() => _remainingSeconds--);
            final halfwaySeconds = _totalDurationSeconds ~/ 2;
            if (_totalDurationSeconds > 60 && _remainingSeconds == halfwaySeconds) {
              _speakEvent('halfway');
            } else if (_remainingSeconds == 60) {
              _speakEvent('one_min');
            }
          } else {
            _timer?.cancel();
            setState(() => _isRunning = false);
            _speakEvent('complete');
            _showCompletionDialog();
          }
        }
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 Session Complete!'),
        content: const Text('Great focus! Take a break or start another round.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetTimer();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final voiceState = ref.watch(pomodoroVoiceSettingsProvider);

    final progress = _totalDurationSeconds > 0
        ? (_remainingSeconds / _totalDurationSeconds).clamp(0.0, 1.0)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pomodoro Focus'),
            Text(
              'Deep Work, Voice Guidance & Ambient Sounds',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          children: [
            // Mode Segmented Bar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: List.generate(_modes.length, (idx) {
                  final isSelected = idx == _selectedModeIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedModeIndex = idx);
                        _resetTimer();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _modes[idx]['name'] as String,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: AppConstants.space6),

            // Circular Progress Countdown
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: _selectedModeIndex == 3 ? 1.0 : progress,
                    strokeWidth: 12,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _modes[_selectedModeIndex]['name'] as String,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            // Controls (Start / Pause / Reset)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.refresh_rounded),
                  iconSize: 28,
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: AppConstants.space4),
                SizedBox(
                  width: 130,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _toggleTimer,
                    icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    label: Text(_isRunning ? 'Pause' : 'Start'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            // Voice Guidance Control Panel
            Container(
              padding: const EdgeInsets.all(AppConstants.space3),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: voiceState.voiceEnabled
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: voiceState.voiceEnabled
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      voiceState.voiceEnabled
                          ? Icons.record_voice_over_rounded
                          : Icons.voice_over_off_rounded,
                      color: voiceState.voiceEnabled
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppConstants.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voice Guidance',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          voiceState.voiceEnabled
                              ? '${voiceState.persona.label} • Active'
                              : 'Voice Alerts Muted',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.tune_rounded),
                    tooltip: 'Voice Options',
                    onPressed: () => PomodoroVoiceSettingsSheet.show(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.space5),

            // White Noise Sound Selector
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ambient White Noise',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space3),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppConstants.space3,
                mainAxisSpacing: AppConstants.space3,
                childAspectRatio: 1.1,
              ),
              itemCount: _sounds.length,
              itemBuilder: (ctx, idx) {
                final item = _sounds[idx];
                final isSelected = item['name'] == _selectedSound;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSound = item['name'] as String);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? colorScheme.primary : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                          size: 26,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['name'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
