import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../features/settings/application/preferences_provider.dart';
import '../../features/tasks/application/tasks_provider.dart';

/// App shell widget hosting the bottom navigation bar and the
/// indexed navigation stack. Handles PRD Section 7 Back Navigation contract:
/// Returns to configured home destination before allowing Android system exit.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesNotifierProvider);
    final homeIndex = prefs.defaultLandingPage.clamp(0, 3);
    final isAtHome = navigationShell.currentIndex == homeIndex;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppConstants.breakpointMedium;

    return PopScope(
      canPop: isAtHome,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !isAtHome) {
          navigationShell.goBranch(
            homeIndex,
            initialLocation: true,
          );
        }
      },
      child: isWide
          ? _WideLayout(navigationShell: navigationShell)
          : _NarrowLayout(navigationShell: navigationShell),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Phone layout — bottom navigation bar
// ──────────────────────────────────────────────────────────────────────────

class _NarrowLayout extends ConsumerWidget {
  const _NarrowLayout({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayCountAsync = ref.watch(todayTaskCountProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox_rounded),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: todayCountAsync.when(
              data: (count) => count > 0
                  ? Badge(
                      label: Text('$count'),
                      child: const Icon(Icons.wb_sunny_outlined),
                    )
                  : const Icon(Icons.wb_sunny_outlined),
              loading: () => const Icon(Icons.wb_sunny_outlined),
              error: (_, __) => const Icon(Icons.wb_sunny_outlined),
            ),
            selectedIcon: const Icon(Icons.wb_sunny_rounded),
            label: 'Today',
          ),
          const NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
            label: 'Projects',
          ),
          const NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'All Tasks',
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Tablet/desktop layout — navigation rail with side panel
// ──────────────────────────────────────────────────────────────────────────

class _WideLayout extends ConsumerWidget {
  const _WideLayout({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            extended: MediaQuery.of(context).size.width >= AppConstants.breakpointExpanded,
            leading: const SizedBox(height: AppConstants.space4),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.space4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        tooltip: 'Completed',
                        onPressed: () => context.push('/completed'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inbox_outlined),
                selectedIcon: Icon(Icons.inbox_rounded),
                label: Text('Inbox'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.wb_sunny_outlined),
                selectedIcon: Icon(Icons.wb_sunny_rounded),
                label: Text('Today'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_open_outlined),
                selectedIcon: Icon(Icons.folder_rounded),
                label: Text('Projects'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt_rounded),
                label: Text('All Tasks'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
