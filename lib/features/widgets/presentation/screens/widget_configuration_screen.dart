import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/widget_configuration.dart';
import '../../domain/widget_snapshot_model.dart';
import '../../application/widget_snapshot_service.dart';
import '../widgets/widget_preview_card.dart';

/// Dedicated configuration screen for Orbit Todo home-screen widgets (PRD Section 8).
class WidgetConfigurationScreen extends ConsumerStatefulWidget {
  const WidgetConfigurationScreen({super.key});

  @override
  ConsumerState<WidgetConfigurationScreen> createState() => _WidgetConfigurationScreenState();
}

class _WidgetConfigurationScreenState extends ConsumerState<WidgetConfigurationScreen> {
  WidgetConfig _config = const WidgetConfig(widgetId: 'primary');
  final WidgetSnapshotData _sampleSnapshot = WidgetSnapshotData(
    timestamp: DateTime.now().toIso8601String(),
    widgetType: 'today',
    totalCount: 4,
    overdueCount: 1,
    items: const [
      WidgetTaskItem(id: '1', title: 'Review Product PRD & Widget Specs', isOverdue: true),
      WidgetTaskItem(id: '2', title: 'Finalize core app design system'),
      WidgetTaskItem(id: '3', title: 'Test Android Glance & WidgetKit parity'),
      WidgetTaskItem(id: '4', title: 'Submit release build to QA'),
    ],
    focusTask: const WidgetTaskItem(id: '1', title: 'Review Product PRD & Widget Specs', isOverdue: true),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen Widgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Diagnostics & Debug',
            onPressed: () => context.push('/settings/widget-diagnostics'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.space4),
        children: [
          Text(
            'LIVE WIDGET PREVIEW',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space3),

          // Widget Preview Carousels
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                WidgetPreviewCard(
                  widgetType: 'today',
                  size: 'medium',
                  snapshot: _sampleSnapshot,
                  config: _config,
                ),
                const SizedBox(width: AppConstants.space3),
                WidgetPreviewCard(
                  widgetType: 'focus',
                  size: 'small',
                  snapshot: _sampleSnapshot,
                  config: _config,
                ),
                const SizedBox(width: AppConstants.space3),
                WidgetPreviewCard(
                  widgetType: 'quick_add',
                  size: 'small',
                  snapshot: _sampleSnapshot,
                  config: _config,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space6),
          const Divider(),
          const SizedBox(height: AppConstants.space3),

          Text(
            'WIDGET CONFIGURATION',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space3),

          SwitchListTile(
            title: const Text('Widget Title Visibility'),
            subtitle: const Text('Show "Today", "Inbox", or "Focus" header'),
            value: _config.titleVisible,
            onChanged: (val) {
              setState(() {
                _config = _config.copyWith(titleVisible: val);
              });
            },
          ),

          SwitchListTile(
            title: const Text('Include Overdue Tasks'),
            subtitle: const Text('Group overdue tasks in Today widgets'),
            value: _config.showOverdue,
            onChanged: (val) {
              setState(() {
                _config = _config.copyWith(showOverdue: val);
              });
            },
          ),

          ListTile(
            title: const Text('Focus Task Source'),
            subtitle: Text(_config.focusSourceMode == 'auto'
                ? 'Automatic (Top Today task)'
                : 'Pinned Task'),
            trailing: DropdownButton<String>(
              value: _config.focusSourceMode,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _config = _config.copyWith(focusSourceMode: val);
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: 'auto', child: Text('Automatic')),
                DropdownMenuItem(value: 'pinned', child: Text('Pinned')),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.space6),

          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Rebuild & Sync Widgets Now'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.space4),
            ),
            onPressed: () async {
              await ref.read(widgetSnapshotServiceProvider).rebuildAllSnapshots();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Widget snapshots rebuilt and refreshed!')),
                );
              }
            },
          ),

          const SizedBox(height: AppConstants.space4),

          OutlinedButton.icon(
            icon: const Icon(Icons.developer_mode_rounded),
            label: const Text('Open Widget Diagnostics Log'),
            onPressed: () => context.push('/settings/widget-diagnostics'),
          ),
        ],
      ),
    );
  }
}
