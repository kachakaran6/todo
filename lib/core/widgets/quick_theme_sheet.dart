import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../theme/color_tokens.dart';
import '../theme/font_tokens.dart';
import '../../features/settings/application/preferences_provider.dart';

/// Shows a quick 1-tap Theme Mode, Accent Color, & Font Style picker sheet.
void showQuickThemeSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const QuickThemeSheet(),
  );
}

class QuickThemeSheet extends ConsumerWidget {
  const QuickThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider);
    final notifier = ref.read(preferencesNotifierProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppConstants.space5,
        AppConstants.space3,
        AppConstants.space5,
        MediaQuery.of(context).padding.bottom + AppConstants.space5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.space4),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.palette_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.space3),
                  Text(
                    'Theme & Appearance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'All Settings',
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space4),

          // ── Theme Mode Options ───────────────────────────────────────────
          Text(
            'APPEARANCE MODE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space2),
          Row(
            children: [
              _ThemeModeCard(
                mode: ThemeMode.light,
                label: 'Light',
                icon: Icons.light_mode_rounded,
                isSelected: prefs.themeMode == ThemeMode.light,
                onTap: () => notifier.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(width: AppConstants.space2),
              _ThemeModeCard(
                mode: ThemeMode.dark,
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
                isSelected: prefs.themeMode == ThemeMode.dark,
                onTap: () => notifier.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(width: AppConstants.space2),
              _ThemeModeCard(
                mode: ThemeMode.system,
                label: 'System',
                icon: Icons.brightness_auto_rounded,
                isSelected: prefs.themeMode == ThemeMode.system,
                onTap: () => notifier.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space4),

          // ── Accent Color Swatches ─────────────────────────────────────────
          Text(
            'ACCENT COLOR',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: AccentTheme.values.map((accent) {
                final isSelected = prefs.accentTheme == accent;
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.space2),
                  child: InkWell(
                    onTap: () => notifier.setAccentTheme(accent),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.space3,
                        vertical: AppConstants.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accent.swatch.withValues(alpha: 0.15)
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? accent.swatch
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.swatch,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 12,
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
                                  : colorScheme.onSurface,
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
          const SizedBox(height: AppConstants.space4),

          // ── Font Style Selector (PRD Requirement 9) ──────────────────────
          Text(
            'FONT STYLE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space2),
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
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.space3,
                        vertical: AppConstants.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            font.displayName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: AppConstants.space1),
                            Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                          ],
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
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  const _ThemeModeCard({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeMode mode;
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
          duration: const Duration(milliseconds: 200),
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
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: AppConstants.space1),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
