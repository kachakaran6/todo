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
import 'shell.dart';

/// All GoRouter route definitions for Orbit Todo.
final router = GoRouter(
  initialLocation: '/inbox',
  debugLogDiagnostics: false,
  routes: [
    // Main shell with persistent navigation
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

        // Branch 1: Today
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/today',
              name: 'today',
              builder: (context, state) => const TodayScreen(),
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

        // Branch 3: Pomodoro Focus
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pomodoro',
              name: 'pomodoro',
              builder: (context, state) => const PomodoroScreen(),
            ),
          ],
        ),

        // Branch 4: Projects
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
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
