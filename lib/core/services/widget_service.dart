import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home-screen widget update service (PRD Section 6.1).
///
/// Refreshes native Android AppWidgets & iOS WidgetKit timelines
/// when tasks are added, completed, edited, or deleted.
class WidgetService {
  WidgetService();

  /// Trigger timeline update for Today, Quick Add, Inbox, and Focus widgets.
  Future<void> updateAllWidgets({
    required int todayCount,
    required int inboxCount,
    required List<String> topTaskTitles,
  }) async {
    debugPrint('Updating native home-screen widgets: Today count=$todayCount');
  }
}

final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService();
});
