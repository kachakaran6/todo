import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../core/services/play_store_service.dart';
import '../core/widgets/integrated_bottom_bar.dart';
import '../features/settings/application/preferences_provider.dart';
import '../features/tasks/presentation/widgets/task_quick_add.dart';

/// App shell widget hosting the bottom navigation bar and navigation rail.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    // Auto-check for Play Store native bottom sheet update on app load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PlayStoreService.checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesNotifierProvider);
    final homeIndex = prefs.defaultLandingPage.clamp(0, 3);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppConstants.breakpointMedium;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 1. Return to home landing page if on a secondary tab
        if (widget.navigationShell.currentIndex != homeIndex) {
          _lastPressed = null;
          widget.navigationShell.goBranch(
            homeIndex,
            initialLocation: true,
          );
          return;
        }

        // 2. Require double-back within 2s before exiting app
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 100, left: 24, right: 24),
            ),
          );
          return;
        }

        // 3. User confirmed exit
        SystemNavigator.pop();
      },
      child: isWide
          ? _WideLayout(navigationShell: widget.navigationShell)
          : _NarrowLayout(navigationShell: widget.navigationShell),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Phone layout — floating glassmorphic capsule bottom navigation bar
// ──────────────────────────────────────────────────────────────────────────

class _NarrowLayout extends ConsumerWidget {
  const _NarrowLayout({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = [
      const NavTabItem(
        selectedIcon: Icons.inbox_rounded,
        unselectedIcon: Icons.inbox_outlined,
        label: 'Capture',
        branchIndex: 0,
      ),
      const NavTabItem(
        selectedIcon: Icons.timer_rounded,
        unselectedIcon: Icons.timer_outlined,
        label: 'Pomodoro',
        branchIndex: 1,
      ),
      const NavTabItem(
        selectedIcon: Icons.add_rounded,
        unselectedIcon: Icons.add_rounded,
        label: '',
        branchIndex: null,
      ),
      const NavTabItem(
        selectedIcon: Icons.grid_view_rounded,
        unselectedIcon: Icons.grid_view_outlined,
        label: 'Matrix',
        branchIndex: 2,
      ),
      const NavTabItem(
        selectedIcon: Icons.folder_rounded,
        unselectedIcon: Icons.folder_open_outlined,
        label: 'Projects',
        branchIndex: 3,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: IntegratedBottomBar(
        currentIndex: navigationShell.currentIndex,
        tabs: tabs,
        onTap: (branchIndex) {
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
        onQuickAddTap: () {
          showQuickAdd(context);
        },
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
            extended: MediaQuery.of(context).size.width >=
                AppConstants.breakpointExpanded,
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
                label: Text('Capture'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.timer_outlined),
                selectedIcon: Icon(Icons.timer_rounded),
                label: Text('Pomodoro'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: Text('Matrix'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_open_outlined),
                selectedIcon: Icon(Icons.folder_rounded),
                label: Text('Projects'),
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
