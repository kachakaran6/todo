import 'package:flutter/material.dart';

/// Segmented Action Switcher Chip
Widget buildFormatSwitcherChip(
  BuildContext context,
  String label,
  IconData icon,
  VoidCallback onTap, {
  bool isSelected = false,
}) {
  final theme = Theme.of(context);
  final activeColor = theme.colorScheme.primary;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? activeColor.withValues(alpha: 0.18)
            : activeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? activeColor.withValues(alpha: 0.4) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: activeColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: activeColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class FormatSwitcherChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const FormatSwitcherChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return buildFormatSwitcherChip(context, label, icon, onTap, isSelected: isSelected);
  }
}
