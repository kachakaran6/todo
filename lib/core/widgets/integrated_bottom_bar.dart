import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class NavTabItem {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final int? branchIndex;
  final Widget? badge;

  const NavTabItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    this.branchIndex,
    this.badge,
  });
}

/// Luna Floating Glassmorphic Bottom Navigation Bar
class IntegratedBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onQuickAddTap;
  final List<NavTabItem>? tabs;

  const IntegratedBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onQuickAddTap,
    this.tabs,
  });

  static const List<NavTabItem> _defaultTabs = [
    NavTabItem(
      selectedIcon: Icons.inbox_rounded,
      unselectedIcon: Icons.inbox_outlined,
      label: 'Capture',
      branchIndex: 0,
    ),
    NavTabItem(
      selectedIcon: Icons.timer_rounded,
      unselectedIcon: Icons.timer_outlined,
      label: 'Pomodoro',
      branchIndex: 1,
    ),
    NavTabItem(
      selectedIcon: Icons.add_rounded,
      unselectedIcon: Icons.add_rounded,
      label: '',
      branchIndex: null,
    ),
    NavTabItem(
      selectedIcon: Icons.grid_view_rounded,
      unselectedIcon: Icons.grid_view_outlined,
      label: 'Matrix',
      branchIndex: 2,
    ),
    NavTabItem(
      selectedIcon: Icons.folder_rounded,
      unselectedIcon: Icons.folder_open_outlined,
      label: 'Projects',
      branchIndex: 3,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeTabs = tabs ?? _defaultTabs;

    final barBg = isDark
        ? const Color(0xFF1B1D24).withValues(alpha: 0.88)
        : Colors.white.withValues(alpha: 0.88);

    final activeColor = theme.colorScheme.primary;
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.40);

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: barBg,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.06),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(activeTabs.length, (index) {
                final tab = activeTabs[index];

                // Center Floating Action Button (index 2 or branchIndex null)
                if (tab.branchIndex == null || index == 2) {
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onQuickAddTap();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.fabCoralGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? AppColors.deepCoralRose.withValues(alpha: 0.30)
                                : AppColors.deepCoralRose.withValues(alpha: 0.18),
                            blurRadius: 10,
                            spreadRadius: -2,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],

                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                    ),
                  );
                }

                final targetBranch = tab.branchIndex ?? index;
                final isSelected = currentIndex == targetBranch;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(targetBranch);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: isSelected ? 1.15 : 1.0,
                            curve: Curves.easeOutBack,
                            child: tab.badge != null
                                ? Badge(
                                    label: tab.badge,
                                    child: Icon(
                                      isSelected ? tab.selectedIcon : tab.unselectedIcon,
                                      size: 23,
                                      color: isSelected ? activeColor : inactiveColor,
                                    ),
                                  )
                                : Icon(
                                    isSelected ? tab.selectedIcon : tab.unselectedIcon,
                                    size: 23,
                                    color: isSelected ? activeColor : inactiveColor,
                                  ),
                          ),
                          const SizedBox(height: 2),
                          // Subtle Active Indicator Bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(bottom: 2),
                            width: isSelected ? 12 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              color: isSelected ? activeColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? activeColor : inactiveColor,
                              fontFamily: theme.textTheme.bodySmall?.fontFamily,
                            ),
                            child: Text(
                              tab.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
