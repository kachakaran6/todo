import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import '../../application/pomodoro_voice_provider.dart';
import '../../application/pomodoro_voice_service.dart';

class PomodoroVoiceSettingsSheet extends ConsumerWidget {
  const PomodoroVoiceSettingsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const PomodoroVoiceSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pomodoroVoiceSettingsProvider);
    final notifier = ref.read(pomodoroVoiceSettingsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (ctx, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppConstants.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppConstants.space3),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.record_voice_over_rounded, color: colorScheme.primary),
                      const SizedBox(width: AppConstants.space2),
                      Text(
                        'Voice Guidance',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.space3),

              // Master Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Enable Voice Announcements',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Spoken progress and timer alerts during focus sessions'),
                value: settings.voiceEnabled,
                onChanged: (val) => notifier.setVoiceEnabled(val),
              ),

              const Divider(),
              const SizedBox(height: AppConstants.space2),

              // Voice Persona Selector
              Text(
                'Voice Persona',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space2),

              Wrap(
                spacing: AppConstants.space2,
                runSpacing: AppConstants.space2,
                children: VoicePersona.values.map((persona) {
                  final isSelected = settings.persona == persona;
                  return ChoiceChip(
                    label: Text(persona.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        notifier.setPersona(persona);
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppConstants.space3),

              // Test Voice Button
              OutlinedButton.icon(
                onPressed: () {
                  PomodoroVoiceService().speak(
                    'Hello! This is your ${settings.persona.label} for Pomodoro focus sessions.',
                    volume: settings.volume,
                    rate: settings.rate,
                    pitch: settings.pitch,
                  );
                },
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('Test Voice Sample'),
              ),

              const SizedBox(height: AppConstants.space4),
              const Divider(),
              const SizedBox(height: AppConstants.space2),

              // Sliders (Rate, Pitch, Volume)
              Text(
                'Audio Fine-Tuning',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space2),

              // Speech Speed Slider
              Text('Speech Rate: ${(settings.rate * 100).toInt()}%'),
              Slider(
                value: settings.rate,
                min: 0.3,
                max: 1.0,
                divisions: 14,
                label: '${(settings.rate * 100).toInt()}%',
                onChanged: (val) => notifier.setRate(val),
              ),

              // Pitch Slider
              Text('Voice Pitch: ${settings.pitch.toStringAsFixed(2)}'),
              Slider(
                value: settings.pitch,
                min: 0.5,
                max: 1.5,
                divisions: 10,
                label: settings.pitch.toStringAsFixed(2),
                onChanged: (val) => notifier.setPitch(val),
              ),

              // Volume Slider
              Text('Voice Volume: ${(settings.volume * 100).toInt()}%'),
              Slider(
                value: settings.volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(settings.volume * 100).toInt()}%',
                onChanged: (val) => notifier.setVolume(val),
              ),

              const SizedBox(height: AppConstants.space3),
              const Divider(),
              const SizedBox(height: AppConstants.space2),

              // Milestone Alerts Toggles
              Text(
                'Milestone Spoken Alerts',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.space2),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Announce Session Start & Resume'),
                value: settings.announceStart,
                onChanged: (val) => notifier.setAnnounceStart(val ?? true),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Announce 50% Halfway Mark'),
                value: settings.announceHalfway,
                onChanged: (val) => notifier.setAnnounceHalfway(val ?? true),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Announce 1-Minute Warning'),
                value: settings.announceOneMinWarning,
                onChanged: (val) => notifier.setAnnounceOneMinWarning(val ?? true),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Announce Session Completion'),
                value: settings.announceCompletion,
                onChanged: (val) => notifier.setAnnounceCompletion(val ?? true),
              ),
            ],
          ),
        );
      },
    );
  }
}
