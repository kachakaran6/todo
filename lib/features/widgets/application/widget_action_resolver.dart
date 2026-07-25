import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widget_diagnostics_service.dart';

/// Class representing the outcome of resolving a widget action or URI.
class WidgetActionResult {
  final String targetRoute;
  final bool isFallback;
  final String? originalUri;
  final String? actionName;
  final String? taskId;

  const WidgetActionResult({
    required this.targetRoute,
    this.isFallback = false,
    this.originalUri,
    this.actionName,
    this.taskId,
  });
}

/// Centralized resolver for native widget actions and deep links (PRD Section 4.3 & 6.3).
/// Normalizes external URIs (`orbit://...`) or JSON payloads into valid in-app routes,
/// ensuring 100% route safety and safe universal fallback behavior.
class WidgetActionResolver {
  final WidgetDiagnosticsService _diagnostics;

  WidgetActionResolver(this._diagnostics);

  /// Approved target routes allowlist (PRD Section 4.1).
  static const String routeInbox = '/inbox';
  static const String routeToday = '/today';
  static const String routeFocus = '/pomodoro';
  static const String routeTasks = '/tasks';

  /// Resolves an incoming URI string into an internal app route.
  WidgetActionResult resolveUri(String inputUri) {
    final sw = Stopwatch()..start();
    final trimmed = inputUri.trim();

    if (trimmed.isEmpty) {
      _diagnostics.logEvent(
        eventType: 'widget_navigation_fallback',
        widgetType: 'uri',
        durationMs: sw.elapsedMilliseconds,
        outcome: 'fallback',
        reasonCode: 'EMPTY_URI_INPUT',
      );
      return WidgetActionResult(
        targetRoute: routeInbox,
        isFallback: true,
        originalUri: inputUri,
      );
    }

    try {
      final uri = Uri.parse(trimmed);

      // Handle canonical scheme: orbit://
      if (uri.scheme.toLowerCase() == 'orbit') {
        final authority = uri.host.toLowerCase();
        final pathSegments = uri.pathSegments;

        // Pattern A: orbit://app/<destination>
        if (authority == 'app') {
          if (pathSegments.isEmpty) {
            return _resolveSuccess(routeInbox, inputUri, 'open_home', sw);
          }
          final firstSeg = pathSegments.first.toLowerCase();
          switch (firstSeg) {
            case 'inbox':
              return _resolveSuccess(routeInbox, inputUri, 'open_inbox', sw);
            case 'today':
              return _resolveSuccess(routeToday, inputUri, 'open_today', sw);
            case 'quick-add':
            case 'quick_add':
              return _resolveSuccess(routeInbox, inputUri, 'open_quick_add', sw);
            case 'focus':
              return _resolveSuccess(routeFocus, inputUri, 'open_focus', sw);
            case 'task':
              if (pathSegments.length >= 2 && pathSegments[1].isNotEmpty) {
                final taskId = pathSegments[1];
                return _resolveSuccess('/task/$taskId', inputUri, 'open_task', sw, taskId: taskId);
              }
              return _resolveSuccess(routeInbox, inputUri, 'open_tasks', sw);
            default:
              return _resolveFallback(inputUri, 'UNRECOGNIZED_APP_PATH', sw);
          }
        }

        // Pattern B: Legacy orbit://inbox, orbit://inbox/, orbit://today, orbit://quick_add, etc.
        switch (authority) {
          case 'inbox':
            return _resolveSuccess(routeInbox, inputUri, 'open_inbox', sw);
          case 'today':
            return _resolveSuccess(routeToday, inputUri, 'open_today', sw);
          case 'quick-add':
          case 'quick_add':
            return _resolveSuccess(routeInbox, inputUri, 'open_quick_add', sw);
          case 'focus':
            return _resolveSuccess(routeFocus, inputUri, 'open_focus', sw);
          case 'task':
            if (pathSegments.isNotEmpty && pathSegments.first.isNotEmpty) {
              final taskId = pathSegments.first;
              return _resolveSuccess('/task/$taskId', inputUri, 'open_task', sw, taskId: taskId);
            }
            return _resolveSuccess(routeInbox, inputUri, 'open_tasks', sw);
          case 'home':
            return _resolveSuccess(routeInbox, inputUri, 'open_home', sw);
          default:
            return _resolveFallback(inputUri, 'UNRECOGNIZED_LEGACY_HOST', sw);
        }
      }

      // Direct internal path string e.g. "/inbox", "/today", "/task/xyz"
      if (trimmed.startsWith('/')) {
        if (trimmed == '/inbox' || trimmed == '/today' || trimmed == '/pomodoro' || trimmed == '/matrix' || trimmed == '/projects' || trimmed == '/tasks' || trimmed.startsWith('/task/')) {
          return _resolveSuccess(trimmed, inputUri, 'direct_path', sw);
        }
      }

      return _resolveFallback(inputUri, 'UNSUPPORTED_SCHEME_OR_FORMAT', sw);
    } catch (e) {
      return _resolveFallback(inputUri, 'PARSE_EXCEPTION', sw);
    }
  }

  /// Resolves a canonical structured widget command payload (PRD Section 4.2).
  WidgetActionResult resolveActionPayload(Map<String, dynamic> json) {
    final sw = Stopwatch()..start();
    final action = json['action']?.toString() ?? 'open_inbox';
    final taskId = json['taskId']?.toString();

    switch (action) {
      case 'open_inbox':
        return _resolveSuccess(routeInbox, null, action, sw);
      case 'open_today':
        return _resolveSuccess(routeToday, null, action, sw);
      case 'open_quick_add':
        return _resolveSuccess(routeInbox, null, action, sw);
      case 'open_focus':
        return _resolveSuccess(routeFocus, null, action, sw);
      case 'open_task':
        if (taskId != null && taskId.isNotEmpty) {
          return _resolveSuccess('/task/$taskId', null, action, sw, taskId: taskId);
        }
        return _resolveSuccess(routeInbox, null, action, sw);
      case 'open_home':
      default:
        return _resolveSuccess(routeInbox, null, action, sw);
    }
  }

  WidgetActionResult _resolveSuccess(
    String route,
    String? rawUri,
    String actionName,
    Stopwatch sw, {
    String? taskId,
  }) {
    _diagnostics.logEvent(
      eventType: 'widget_navigation_resolved',
      widgetType: 'action',
      durationMs: sw.elapsedMilliseconds,
      outcome: 'success',
      reasonCode: actionName,
    );
    return WidgetActionResult(
      targetRoute: route,
      isFallback: false,
      originalUri: rawUri,
      actionName: actionName,
      taskId: taskId,
    );
  }

  WidgetActionResult _resolveFallback(String? rawUri, String reasonCode, Stopwatch sw) {
    _diagnostics.logEvent(
      eventType: 'widget_navigation_fallback',
      widgetType: 'action',
      durationMs: sw.elapsedMilliseconds,
      outcome: 'fallback',
      reasonCode: reasonCode,
    );
    return WidgetActionResult(
      targetRoute: routeInbox,
      isFallback: true,
      originalUri: rawUri,
    );
  }
}

final widgetActionResolverProvider = Provider<WidgetActionResolver>((ref) {
  final diagnostics = ref.watch(widgetDiagnosticsServiceProvider);
  return WidgetActionResolver(diagnostics);
});
