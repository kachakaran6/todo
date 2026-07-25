/// Model for per-instance home screen widget configuration.
class WidgetConfig {
  final String widgetId;
  final bool titleVisible;
  final String? listFilterId;
  final int maxTaskCount;
  final bool showOverdue;
  final String todayContextMode; // 'date', 'count', 'both', 'none'
  final String focusSourceMode; // 'pinned', 'auto'
  final String? pinnedFocusTaskId;
  final String accentTreatment; // 'theme', 'neutral'

  const WidgetConfig({
    required this.widgetId,
    this.titleVisible = true,
    this.listFilterId,
    this.maxTaskCount = 6,
    this.showOverdue = true,
    this.todayContextMode = 'both',
    this.focusSourceMode = 'auto',
    this.pinnedFocusTaskId,
    this.accentTreatment = 'theme',
  });

  WidgetConfig copyWith({
    bool? titleVisible,
    String? listFilterId,
    int? maxTaskCount,
    bool? showOverdue,
    String? todayContextMode,
    String? focusSourceMode,
    String? pinnedFocusTaskId,
    String? accentTreatment,
  }) {
    return WidgetConfig(
      widgetId: widgetId,
      titleVisible: titleVisible ?? this.titleVisible,
      listFilterId: listFilterId ?? this.listFilterId,
      maxTaskCount: maxTaskCount ?? this.maxTaskCount,
      showOverdue: showOverdue ?? this.showOverdue,
      todayContextMode: todayContextMode ?? this.todayContextMode,
      focusSourceMode: focusSourceMode ?? this.focusSourceMode,
      pinnedFocusTaskId: pinnedFocusTaskId ?? this.pinnedFocusTaskId,
      accentTreatment: accentTreatment ?? this.accentTreatment,
    );
  }

  Map<String, dynamic> toJson() => {
        'widgetId': widgetId,
        'titleVisible': titleVisible,
        'listFilterId': listFilterId,
        'maxTaskCount': maxTaskCount,
        'showOverdue': showOverdue,
        'todayContextMode': todayContextMode,
        'focusSourceMode': focusSourceMode,
        'pinnedFocusTaskId': pinnedFocusTaskId,
        'accentTreatment': accentTreatment,
      };

  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    return WidgetConfig(
      widgetId: json['widgetId'] as String? ?? 'default',
      titleVisible: json['titleVisible'] as bool? ?? true,
      listFilterId: json['listFilterId'] as String?,
      maxTaskCount: json['maxTaskCount'] as int? ?? 6,
      showOverdue: json['showOverdue'] as bool? ?? true,
      todayContextMode: json['todayContextMode'] as String? ?? 'both',
      focusSourceMode: json['focusSourceMode'] as String? ?? 'auto',
      pinnedFocusTaskId: json['pinnedFocusTaskId'] as String?,
      accentTreatment: json['accentTreatment'] as String? ?? 'theme',
    );
  }
}
