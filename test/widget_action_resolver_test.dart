import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_todo/features/widgets/application/widget_action_resolver.dart';
import 'package:orbit_todo/features/widgets/application/widget_diagnostics_service.dart';

void main() {
  late WidgetActionResolver resolver;
  late WidgetDiagnosticsService diagnostics;

  setUp(() {
    diagnostics = WidgetDiagnosticsService.instance;
    diagnostics.clearLogs();
    resolver = WidgetActionResolver(diagnostics);
  });

  group('WidgetActionResolver — Canonical URI Resolution (PRD Section 4.3)', () {
    test('orbit://app/inbox resolves to /inbox', () {
      final result = resolver.resolveUri('orbit://app/inbox');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
      expect(result.actionName, equals('open_inbox'));
    });

    test('orbit://app/today resolves to /today', () {
      final result = resolver.resolveUri('orbit://app/today');
      expect(result.targetRoute, equals('/today'));
      expect(result.isFallback, isFalse);
      expect(result.actionName, equals('open_today'));
    });

    test('orbit://app/quick-add resolves to /inbox', () {
      final result = resolver.resolveUri('orbit://app/quick-add');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
      expect(result.actionName, equals('open_quick_add'));
    });

    test('orbit://app/focus resolves to /pomodoro', () {
      final result = resolver.resolveUri('orbit://app/focus');
      expect(result.targetRoute, equals('/pomodoro'));
      expect(result.isFallback, isFalse);
      expect(result.actionName, equals('open_focus'));
    });

    test('orbit://app/task/task-123 resolves to /task/task-123', () {
      final result = resolver.resolveUri('orbit://app/task/task-123');
      expect(result.targetRoute, equals('/task/task-123'));
      expect(result.isFallback, isFalse);
      expect(result.taskId, equals('task-123'));
    });
  });

  group('WidgetActionResolver — Legacy & Defect Remediation URIs (PRD Section 1.1 & 4.3)', () {
    test('orbit://inbox/ (reported defect URI) resolves safely to /inbox', () {
      final result = resolver.resolveUri('orbit://inbox/');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
    });

    test('orbit://inbox resolves to /inbox', () {
      final result = resolver.resolveUri('orbit://inbox');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
    });

    test('orbit://today resolves to /today', () {
      final result = resolver.resolveUri('orbit://today');
      expect(result.targetRoute, equals('/today'));
      expect(result.isFallback, isFalse);
    });

    test('orbit://quick_add resolves to /inbox', () {
      final result = resolver.resolveUri('orbit://quick_add');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
    });
  });

  group('WidgetActionResolver — Safe Universal Fallbacks (PRD Section 4.4)', () {
    test('Malformed URI falls back safely to /inbox without throwing', () {
      final result = resolver.resolveUri('orbit://invalid_destination_xyz/123');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isTrue);

      final logs = diagnostics.getLogs();
      expect(logs.any((l) => l.eventType == 'widget_navigation_fallback'), isTrue);
    });

    test('Empty URI string falls back safely to /inbox', () {
      final result = resolver.resolveUri('');
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isTrue);
    });
  });

  group('WidgetActionResolver — Canonical Payload Resolution (PRD Section 4.2)', () {
    test('open_inbox action payload resolves to /inbox', () {
      final result = resolver.resolveActionPayload({'action': 'open_inbox'});
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
    });

    test('open_task payload with taskId resolves to /task/:taskId', () {
      final result = resolver.resolveActionPayload({
        'action': 'open_task',
        'taskId': 't-999',
      });
      expect(result.targetRoute, equals('/task/t-999'));
      expect(result.isFallback, isFalse);
      expect(result.taskId, equals('t-999'));
    });

    test('unknown action payload falls back to /inbox', () {
      final result = resolver.resolveActionPayload({'action': 'unknown_action'});
      expect(result.targetRoute, equals('/inbox'));
      expect(result.isFallback, isFalse);
    });
  });
}
