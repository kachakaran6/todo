import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/widget_event_log.dart';

/// Service managing structured diagnostics logging and failure simulation tools (PRD Section 11).
class WidgetDiagnosticsService {
  static final WidgetDiagnosticsService instance = WidgetDiagnosticsService._();
  WidgetDiagnosticsService._();

  final List<WidgetEventLog> _eventBuffer = [];
  static const int _maxBufferSize = 200;

  // Simulation flags for testing resilience states
  bool simulateMissingSnapshot = false;
  bool simulateInvalidSchema = false;
  bool simulateStorageFailure = false;
  bool simulateTaskDeleted = false;

  void logEvent({
    required String eventType,
    required String widgetType,
    required int durationMs,
    required String outcome,
    String? reasonCode,
  }) {
    final log = WidgetEventLog(
      correlationId: const Uuid().v4().substring(0, 8),
      eventType: eventType,
      widgetType: widgetType,
      durationMs: durationMs,
      outcome: outcome,
      reasonCode: reasonCode,
    );

    _eventBuffer.insert(0, log);
    if (_eventBuffer.length > _maxBufferSize) {
      _eventBuffer.removeLast();
    }
  }

  List<WidgetEventLog> getLogs() => List.unmodifiable(_eventBuffer);

  void clearLogs() {
    _eventBuffer.clear();
  }

  void resetSimulations() {
    simulateMissingSnapshot = false;
    simulateInvalidSchema = false;
    simulateStorageFailure = false;
    simulateTaskDeleted = false;
  }

  String exportDiagnosticReport() {
    final buf = StringBuffer();
    buf.writeln('=== TaskMitra Widget Diagnostics Report ===');
    buf.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buf.writeln('Simulations Active:');
    buf.writeln('  Missing Snapshot: $simulateMissingSnapshot');
    buf.writeln('  Invalid Schema: $simulateInvalidSchema');
    buf.writeln('  Storage Failure: $simulateStorageFailure');
    buf.writeln('  Task Deleted: $simulateTaskDeleted');
    buf.writeln('\nRecent Diagnostic Events (${_eventBuffer.length}):');
    for (final log in _eventBuffer) {
      buf.writeln(
          '[${log.timestamp.toIso8601String()}] ${log.eventType} (${log.widgetType}) - ${log.outcome} (${log.reasonCode ?? "OK"}) in ${log.durationMs}ms [CID: ${log.correlationId}]');
    }
    return buf.toString();
  }
}

final widgetDiagnosticsServiceProvider = Provider<WidgetDiagnosticsService>((ref) {
  return WidgetDiagnosticsService.instance;
});
