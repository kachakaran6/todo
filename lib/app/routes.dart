import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/inbox/presentation/screens/inbox_screen.dart';
import '../../features/today/presentation/screens/today_screen.dart';
import '../../features/matrix/presentation/screens/matrix_screen.dart';
import '../../features/pomodoro/presentation/screens/pomodoro_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/all_tasks/presentation/screens/all_tasks_screen.dart';
import '../../features/completed/presentation/screens/completed_screen.dart';
import '../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/widgets/presentation/screens/widget_configuration_screen.dart';
import '../../features/widgets/presentation/screens/widget_diagnostics_screen.dart';
import '../../features/widgets/application/widget_action_resolver.dart';
import '../../features/widgets/application/widget_diagnostics_service.dart';
import 'shell.dart';

/// All GoRouter route definitions for Orbit Todo.
final router = GoRouter(
  initialLocation: '/inbox',
  debugLogDiagnostics: false,
  redirect: (context, state) {
    final location = state.uri.toString();
    // Normalize custom scheme deep links or unrecognized URI patterns (PRD Section 4.3 & 6.4)
    if (location.startsWith('orbit://') || location.startsWith('orbit:') || !location.startsWith('/')) {
      final resolver = WidgetActionResolver(WidgetDiagnosticsService.instance);
      final result = resolver.resolveUri(location);
      return result.targetRoute;
    }
    return null;
  },
  errorBuilder: (context, state) {
    WidgetDiagnosticsService.instance.logEvent(
      eventType: 'widget_navigation_fallback',
      widgetType: 'router_error',
      durationMs: 0,
      outcome: 'fallback',
      reasonCode: state.error?.toString() ?? 'UNKNOWN_ROUTE_ERROR',
    );
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.task_alt_rounded,
                size: 64,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 16),
              const Text(
                'Destination Not Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'That item or link is no longer available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/inbox'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Return to Inbox'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
  routes: [
    // Main shell with persistent navigation (4 branches + center FAB)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Capture (Inbox)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              name: 'inbox',
              builder: (context, state) => const InboxScreen(),
            ),
          ],
        ),

        // Branch 1: Pomodoro Focus
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pomodoro',
              name: 'pomodoro',
              builder: (context, state) => const PomodoroScreen(),
            ),
          ],
        ),

        // Branch 2: Priority Matrix
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/matrix',
              name: 'matrix',
              builder: (context, state) => const MatrixScreen(),
            ),
          ],
        ),

        // Branch 3: Projects
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              name: 'projects',
              builder: (context, state) => const ProjectsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Full-screen routes (push on top of shell) ────────────────────────

    GoRoute(
      path: '/today',
      name: 'today',
      builder: (context, state) => const TodayScreen(),
    ),

    GoRoute(
      path: '/task/:id',
      name: 'task_detail',
      builder: (context, state) => TaskDetailScreen(
        taskId: state.pathParameters['id']!,
      ),
    ),

    GoRoute(
      path: '/project/:id',
      name: 'project_detail',
      builder: (context, state) => ProjectDetailScreen(
        projectId: state.pathParameters['id']!,
      ),
    ),

    GoRoute(
      path: '/tasks',
      name: 'all_tasks',
      builder: (context, state) => const AllTasksScreen(),
    ),

    GoRoute(
      path: '/completed',
      name: 'completed',
      builder: (context, state) => const CompletedScreen(),
    ),

    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: '/settings/widgets',
      name: 'widget_configuration',
      builder: (context, state) => const WidgetConfigurationScreen(),
    ),

    GoRoute(
      path: '/settings/widget-diagnostics',
      name: 'widget_diagnostics',
      builder: (context, state) => const WidgetDiagnosticsScreen(),
    ),

    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
