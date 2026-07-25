import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Lightweight task model stored inside widget snapshots for fast rendering.
class WidgetTaskItem {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isOverdue;
  final String? formattedDueDate;
  final String? projectColorHex;
  final int priority;
  final String? listName;

  const WidgetTaskItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isOverdue = false,
    this.formattedDueDate,
    this.projectColorHex,
    this.priority = 0,
    this.listName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'isOverdue': isOverdue,
        'formattedDueDate': formattedDueDate,
        'projectColorHex': projectColorHex,
        'priority': priority,
        'listName': listName,
      };

  factory WidgetTaskItem.fromJson(Map<String, dynamic> json) {
    return WidgetTaskItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      isOverdue: json['isOverdue'] as bool? ?? false,
      formattedDueDate: json['formattedDueDate'] as String?,
      projectColorHex: json['projectColorHex'] as String?,
      priority: json['priority'] as int? ?? 0,
      listName: json['listName'] as String?,
    );
  }
}

/// Precalculated, versioned snapshot data model written atomically for widgets to read.
class WidgetSnapshotData {
  static const int currentSchemaVersion = 1;

  final String timestamp;
  final int schemaVersion;
  final String widgetType; // 'today', 'quick_add', 'inbox', 'focus'
  final int totalCount;
  final int overdueCount;
  final List<WidgetTaskItem> items;
  final WidgetTaskItem? focusTask;
  final String? fallbackMessage;
  final String integrityHash;

  WidgetSnapshotData({
    required this.timestamp,
    this.schemaVersion = currentSchemaVersion,
    required this.widgetType,
    required this.totalCount,
    required this.overdueCount,
    required this.items,
    this.focusTask,
    this.fallbackMessage,
    String? integrityHash,
  }) : integrityHash = integrityHash ??
            _computeHash(timestamp, widgetType, totalCount, items.length);

  static String _computeHash(
      String timestamp, String widgetType, int totalCount, int itemCount) {
    final payload = '$timestamp:$widgetType:$totalCount:$itemCount:v$currentSchemaVersion';
    return sha256.convert(utf8.encode(payload)).toString().substring(0, 16);
  }

  /// PRD Section 9.4 — Snapshot integrity and schema validation check.
  bool get isValid {
    if (schemaVersion > currentSchemaVersion) return false;
    if (totalCount < 0 || overdueCount < 0) return false;
    if (widgetType.isEmpty) return false;
    for (final item in items) {
      if (item.id.isEmpty) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'schemaVersion': schemaVersion,
        'widgetType': widgetType,
        'totalCount': totalCount,
        'overdueCount': overdueCount,
        'items': items.map((e) => e.toJson()).toList(),
        'focusTask': focusTask?.toJson(),
        'fallbackMessage': fallbackMessage,
        'integrityHash': integrityHash,
      };

  factory WidgetSnapshotData.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((e) => WidgetTaskItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final focusJson = json['focusTask'] as Map<String, dynamic>?;

    return WidgetSnapshotData(
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      widgetType: json['widgetType'] as String? ?? 'today',
      totalCount: json['totalCount'] as int? ?? 0,
      overdueCount: json['overdueCount'] as int? ?? 0,
      items: itemsList,
      focusTask: focusJson != null ? WidgetTaskItem.fromJson(focusJson) : null,
      fallbackMessage: json['fallbackMessage'] as String?,
      integrityHash: json['integrityHash'] as String?,
    );
  }

  /// Approved empty state snapshot factory per PRD Section 9.2
  factory WidgetSnapshotData.empty({
    required String widgetType,
    String? message,
  }) {
    final defaultMessage = switch (widgetType) {
      'today' => 'Today is clear.',
      'inbox' => 'Inbox is empty.',
      'focus' => 'Choose one thing to focus on.',
      _ => 'No tasks found.',
    };

    return WidgetSnapshotData(
      timestamp: DateTime.now().toIso8601String(),
      schemaVersion: currentSchemaVersion,
      widgetType: widgetType,
      totalCount: 0,
      overdueCount: 0,
      items: const [],
      fallbackMessage: message ?? defaultMessage,
    );
  }

  /// Approved fallback snapshot factory when current data snapshot is unavailable or corrupt.
  factory WidgetSnapshotData.fallback({
    required String widgetType,
    required String reasonCode,
  }) {
    return WidgetSnapshotData(
      timestamp: DateTime.now().toIso8601String(),
      schemaVersion: currentSchemaVersion,
      widgetType: widgetType,
      totalCount: 0,
      overdueCount: 0,
      items: const [],
      fallbackMessage: 'Open TaskMitra to refresh your tasks.',
    );
  }
}
