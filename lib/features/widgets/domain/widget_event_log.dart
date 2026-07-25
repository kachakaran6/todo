/// Structured event log item for development diagnostics and observability (PRD Section 11).
class WidgetEventLog {
  final String correlationId;
  final String eventType;
  final String widgetType;
  final int durationMs;
  final String outcome; // 'success', 'failure', 'fallback'
  final String? reasonCode;
  final DateTime timestamp;

  WidgetEventLog({
    required this.correlationId,
    required this.eventType,
    required this.widgetType,
    required this.durationMs,
    required this.outcome,
    this.reasonCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'correlationId': correlationId,
        'eventType': eventType,
        'widgetType': widgetType,
        'durationMs': durationMs,
        'outcome': outcome,
        'reasonCode': reasonCode,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WidgetEventLog.fromJson(Map<String, dynamic> json) {
    return WidgetEventLog(
      correlationId: json['correlationId'] as String? ?? '',
      eventType: json['eventType'] as String? ?? 'general',
      widgetType: json['widgetType'] as String? ?? 'unknown',
      durationMs: json['durationMs'] as int? ?? 0,
      outcome: json['outcome'] as String? ?? 'success',
      reasonCode: json['reasonCode'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
