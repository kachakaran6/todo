import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_todo/features/widgets/domain/widget_snapshot_model.dart';
import 'package:orbit_todo/features/widgets/domain/widget_configuration.dart';
import 'package:orbit_todo/features/widgets/application/widget_diagnostics_service.dart';

void main() {
  group('WidgetSnapshotData & Integrity Tests (PRD Section 9.4 & 15.1)', () {
    test('Valid snapshot passes integrity and validation checks', () {
      final snapshot = WidgetSnapshotData(
        timestamp: DateTime.now().toIso8601String(),
        widgetType: 'today',
        totalCount: 3,
        overdueCount: 1,
        items: const [
          WidgetTaskItem(id: 't1', title: 'Task 1', isOverdue: true),
          WidgetTaskItem(id: 't2', title: 'Task 2'),
        ],
      );

      expect(snapshot.isValid, isTrue);
      expect(snapshot.integrityHash.length, equals(16));
      expect(snapshot.schemaVersion, equals(WidgetSnapshotData.currentSchemaVersion));
    });

    test('Snapshot with invalid schema or negative count fails validation', () {
      final invalidSchema = WidgetSnapshotData(
        timestamp: DateTime.now().toIso8601String(),
        schemaVersion: 99,
        widgetType: 'today',
        totalCount: 1,
        overdueCount: 0,
        items: const [WidgetTaskItem(id: 't1', title: 'Test')],
      );

      expect(invalidSchema.isValid, isFalse);

      final negativeCount = WidgetSnapshotData(
        timestamp: DateTime.now().toIso8601String(),
        widgetType: 'today',
        totalCount: -5,
        overdueCount: 0,
        items: const [],
      );

      expect(negativeCount.isValid, isFalse);
    });

    test('Approved empty factory produces valid non-error state (PRD 9.2)', () {
      final emptyToday = WidgetSnapshotData.empty(widgetType: 'today');

      expect(emptyToday.isValid, isTrue);
      expect(emptyToday.fallbackMessage, equals('Today is clear.'));
      expect(emptyToday.totalCount, equals(0));
    });

    test('Approved fallback factory produces valid recovery snapshot (PRD 9.2 & 9.3)', () {
      final fallback = WidgetSnapshotData.fallback(
        widgetType: 'today',
        reasonCode: 'WIDGET_SNAPSHOT_MISSING',
      );

      expect(fallback.isValid, isTrue);
      expect(fallback.fallbackMessage, equals('Open TaskMitra to refresh your tasks.'));
    });
  });

  group('WidgetConfig Serialization Tests (PRD Section 8)', () {
    test('WidgetConfig serializes and deserializes correctly', () {
      const config = WidgetConfig(
        widgetId: 'w100',
        titleVisible: false,
        maxTaskCount: 3,
        todayContextMode: 'date',
        accentTreatment: 'theme',
      );

      final json = config.toJson();
      final restored = WidgetConfig.fromJson(json);

      expect(restored.widgetId, equals('w100'));
      expect(restored.titleVisible, isFalse);
      expect(restored.maxTaskCount, equals(3));
      expect(restored.todayContextMode, equals('date'));
    });
  });

  group('WidgetDiagnosticsService Observability Tests (PRD Section 11)', () {
    test('Logs privacy-safe diagnostic events into rolling buffer', () {
      final diagnostics = WidgetDiagnosticsService.instance;
      diagnostics.clearLogs();

      diagnostics.logEvent(
        eventType: 'snapshot_build',
        widgetType: 'today',
        durationMs: 45,
        outcome: 'success',
      );

      final logs = diagnostics.getLogs();
      expect(logs.length, equals(1));
      expect(logs.first.eventType, equals('snapshot_build'));
      expect(logs.first.outcome, equals('success'));
      expect(logs.first.correlationId.isNotEmpty, isTrue);

      final report = diagnostics.exportDiagnosticReport();
      expect(report.contains('TaskMitra Widget Diagnostics Report'), isTrue);
    });
  });
}
