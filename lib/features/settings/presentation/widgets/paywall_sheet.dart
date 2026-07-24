import 'package:flutter/material.dart';
import 'package:orbit_todo/core/constants/app_constants.dart';

/// Shows the free features unlocked sheet.
void showPaywallSheet(BuildContext context, {String? triggerFeature}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => PaywallSheet(triggerFeature: triggerFeature),
  );
}

class PaywallSheet extends StatelessWidget {
  const PaywallSheet({super.key, this.triggerFeature});

  final String? triggerFeature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppConstants.space5,
        AppConstants.space4,
        AppConstants.space5,
        MediaQuery.of(context).padding.bottom + AppConstants.space5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '100% FREE & UNLOCKED',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),

          // Title
          Text(
            'All Pro Features Are Unlocked!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppConstants.space2),
          Text(
            'No subscriptions, no hidden paywalls. Enjoy the full power of Orbit Todo completely free.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.space5),

          // Pro Features List
          const _FeatureRow(
            icon: Icons.filter_list_rounded,
            title: 'Unlimited Smart Lists',
            subtitle: 'Save complex custom queries and filter rules',
          ),
          const SizedBox(height: AppConstants.space3),
          const _FeatureRow(
            icon: Icons.splitscreen_rounded,
            title: 'Custom Fields & Templates',
            subtitle: 'Attach structured data and reusable blueprints',
          ),
          const SizedBox(height: AppConstants.space3),
          const _FeatureRow(
            icon: Icons.widgets_rounded,
            title: 'Advanced Widgets & Multi-Reminders',
            subtitle: 'Custom focus widgets and precise alarm controls',
          ),
          const SizedBox(height: AppConstants.space6),

          // Dismiss CTA
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.done_all_rounded),
              label: const Text('Awesome, Enjoy Orbit Pro!'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.green),
        ),
        const SizedBox(width: AppConstants.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
