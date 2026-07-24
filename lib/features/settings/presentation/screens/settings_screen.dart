import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/theme/color_tokens.dart';
import 'package:orbit_todo/core/theme/font_tokens.dart';
import 'package:orbit_todo/features/settings/application/preferences_provider.dart';
import 'package:orbit_todo/features/settings/application/data_transfer_service.dart';
import 'package:orbit_todo/features/settings/presentation/widgets/paywall_sheet.dart';
import 'package:orbit_todo/features/settings/domain/user_preferences.dart';

/// Settings screen — theme, accent, font style, landing page, density, and preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider);
    final notifier = ref.read(preferencesNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.space2),
        children: [
          // ── Appearance ──────────────────────────────────────────────────
          const _SectionHeader(label: 'Appearance'),

          // Theme Mode Selector
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space4,
              vertical: AppConstants.space2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.space2),
                Row(
                  children: [
                    _ThemeSelectorCard(
                      label: 'Light',
                      icon: Icons.light_mode_rounded,
                      isSelected: prefs.themeMode == ThemeMode.light,
                      onTap: () => notifier.setThemeMode(ThemeMode.light),
                    ),
                    const SizedBox(width: AppConstants.space2),
                    _ThemeSelectorCard(
                      label: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      isSelected: prefs.themeMode == ThemeMode.dark,
                      onTap: () => notifier.setThemeMode(ThemeMode.dark),
                    ),
                    const SizedBox(width: AppConstants.space2),
                    _ThemeSelectorCard(
                      label: 'System',
                      icon: Icons.brightness_auto_rounded,
                      isSelected: prefs.themeMode == ThemeMode.system,
                      onTap: () => notifier.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space3),

          // Accent Color Swatches
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space4,
              vertical: AppConstants.space2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accent Color',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.space3),
                Wrap(
                  spacing: AppConstants.space3,
                  runSpacing: AppConstants.space3,
                  children: AccentTheme.values.map((accent) {
                    final isSelected = prefs.accentTheme == accent;
                    return InkWell(
                      onTap: () => notifier.setAccentTheme(accent),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.space3,
                          vertical: AppConstants.space2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accent.swatch.withValues(alpha: 0.15)
                              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? accent.swatch : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: accent.swatch,
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.swatch.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: AppConstants.space2),
                            Text(
                              accent.displayName,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? accent.swatch
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space3),

          // Font Style Selector (PRD Requirement 9)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space4,
              vertical: AppConstants.space2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Font Style',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.space1),
                Text(
                  'Choose your preferred typography personality',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppConstants.space3),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: AppFontStyle.values.map((font) {
                      final isSelected = prefs.fontStyle == font;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppConstants.space2),
                        child: InkWell(
                          onTap: () => notifier.setFontStyle(font),
                          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                          child: AnimatedContainer(
                            duration: 200.ms,
                            width: 140,
                            padding: const EdgeInsets.all(AppConstants.space3),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      font.displayName,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.space1),
                                Text(
                                  font.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space2),

          // Task density
          ListTile(
            leading: const Icon(Icons.density_medium_rounded),
            title: const Text('Task density'),
            subtitle: Text(prefs.taskDensity.label),
            onTap: () => _showDensityPicker(context, prefs.taskDensity, notifier),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          ),

          // Default Home Destination (PRD Requirement 6 & 7)
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Default Home Screen'),
            subtitle: Text(_landingPageLabel(prefs.defaultLandingPage)),
            onTap: () => _showLandingPagePicker(context, prefs.defaultLandingPage, notifier),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          ),

          const Divider(height: AppConstants.space6),

          // ── Tasks ────────────────────────────────────────────────────────
          const _SectionHeader(label: 'Tasks'),

          SwitchListTile(
            secondary: const Icon(Icons.check_circle_outline_rounded),
            title: const Text('Show completed in Today'),
            subtitle: const Text('Keeps completed tasks visible on the Today screen'),
            value: prefs.showCompletedInToday,
            onChanged: (v) => notifier.setShowCompletedInToday(v),
          ),

          const Divider(height: AppConstants.space6),

          // ── Data & Backup (PRD Section 7.3) ──────────────────────────────
          const _SectionHeader(label: 'Data & Backup'),

          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Export Local Backup (JSON)'),
            subtitle: const Text('Save tasks, projects, and settings to JSON file'),
            onTap: () async {
              final jsonStr = await ref.read(dataTransferServiceProvider).exportToJson();
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Backup Exported'),
                    content: Text('Exported ${jsonStr.length} characters of backup data.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Import Local Backup (JSON)'),
            subtitle: const Text('Restore tasks and projects from JSON file'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select backup file to restore')),
              );
            },
          ),

          const Divider(height: AppConstants.space6),

          // ── Orbit Pro Features (100% Free) ──────────────────────────────
          const _SectionHeader(label: 'Orbit Pro (100% Free)'),

          ListTile(
            leading: const Icon(Icons.stars_rounded, color: Colors.amber),
            title: const Text('Orbit Pro — All Features Unlocked'),
            subtitle: const Text('Smart Lists, Custom Fields, Templates & Widgets are 100% free'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'UNLOCKED',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: Colors.green,
                ),
              ),
            ),
            onTap: () => showPaywallSheet(context),
          ),

          const Divider(height: AppConstants.space6),

          // ── About ────────────────────────────────────────────────────────
          const _SectionHeader(label: 'About'),

          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Orbit Todo'),
            subtitle: Text('Version 1.0.0 (Expansion Ready)'),
          ),

          ListTile(
            leading: const Icon(Icons.star_outline_rounded),
            title: const Text('Rate the app'),
            onTap: () {},
          ),

          const SizedBox(height: AppConstants.space8),
        ],
      ),
    );
  }

  String _landingPageLabel(int index) => switch (index) {
        0 => 'Inbox',
        1 => 'Today (Default)',
        2 => 'Projects',
        3 => 'All Tasks',
        _ => 'Today',
      };

  void _showLandingPagePicker(
    BuildContext context,
    int current,
    PreferencesNotifier notifier,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default Home Screen', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: AppConstants.space2),
            Text(
              'Pressing Back on non-home screens returns here first.',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppConstants.space4),
            ...[0, 1, 2, 3].map(
              (idx) => ListTile(
                title: Text(_landingPageLabel(idx)),
                trailing: current == idx
                    ? Icon(Icons.check_rounded,
                        color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  notifier.setDefaultLandingPage(idx);
                  Navigator.pop(ctx);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showDensityPicker(
    BuildContext context,
    TaskDensity current,
    PreferencesNotifier notifier,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task density', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: AppConstants.space2),
            Text(
              'Controls the amount of space between tasks in lists.',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppConstants.space4),
            ...TaskDensity.values.map(
              (density) => ListTile(
                title: Text(density.label),
                trailing: current == density
                    ? Icon(Icons.check_rounded,
                        color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  notifier.setTaskDensity(density);
                  Navigator.pop(ctx);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelectorCard extends StatelessWidget {
  const _ThemeSelectorCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.space3,
            horizontal: AppConstants.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: AppConstants.space1),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space4,
        AppConstants.space3,
        AppConstants.space4,
        AppConstants.space1,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
      ),
    );
  }
}
