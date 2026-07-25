import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../application/widget_diagnostics_service.dart';
import '../../application/widget_snapshot_service.dart';

/// Developer debug screen for widget logging, resilience testing, and diagnostic exports (PRD Section 11.4).
class WidgetDiagnosticsScreen extends ConsumerStatefulWidget {
  const WidgetDiagnosticsScreen({super.key});

  @override
  ConsumerState<WidgetDiagnosticsScreen> createState() => _WidgetDiagnosticsScreenState();
}

class _WidgetDiagnosticsScreenState extends ConsumerState<WidgetDiagnosticsScreen> {
  @override
  Widget build(BuildContext context) {
    final diagnostics = ref.watch(widgetDiagnosticsServiceProvider);
    final logs = diagnostics.getLogs();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Diagnostics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Report',
            onPressed: () {
              final report = diagnostics.exportDiagnosticReport();
              Clipboard.setData(ClipboardData(text: report));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnostic report copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Clear Logs',
            onPressed: () {
              setState(() {
                diagnostics.clearLogs();
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.space4),
        children: [
          Text(
            'FAILURE SIMULATION CONTROLS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppConstants.space2),

          SwitchListTile(
            title: const Text('Simulate Missing Snapshot'),
            subtitle: const Text('Forces widget fallback recovery state'),
            value: diagnostics.simulateMissingSnapshot,
            onChanged: (v) {
              setState(() {
                diagnostics.simulateMissingSnapshot = v;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Simulate Invalid Schema'),
            subtitle: const Text('Tests version & schema validation policy'),
            value: diagnostics.simulateInvalidSchema,
            onChanged: (v) {
              setState(() {
                diagnostics.simulateInvalidSchema = v;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Simulate Storage Failure'),
            subtitle: const Text('Tests atomic write failure recovery'),
            value: diagnostics.simulateStorageFailure,
            onChanged: (v) {
              setState(() {
                diagnostics.simulateStorageFailure = v;
              });
            },
          ),

          const SizedBox(height: AppConstants.space4),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Trigger Rebuild'),
                  onPressed: () async {
                    await ref.read(widgetSnapshotServiceProvider).rebuildAllSnapshots();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: AppConstants.space2),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    diagnostics.resetSimulations();
                  });
                },
                child: const Text('Reset Sim'),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.space6),
          const Divider(),
          const SizedBox(height: AppConstants.space3),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT EVENT LOGS (${logs.length})',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'Privacy Safe',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space3),

          if (logs.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.space4),
                child: Text(
                  'No diagnostic events recorded yet. Perform task mutations or tap "Trigger Rebuild".',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...logs.map((log) {
              final isSuccess = log.outcome == 'success';
              final isFallback = log.outcome == 'fallback';

              final statusColor = isSuccess
                  ? Colors.green
                  : (isFallback ? Colors.amber : Colors.red);

              return Card(
                margin: const EdgeInsets.only(bottom: AppConstants.space2),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: statusColor.withValues(alpha: 0.2),
                    child: Icon(
                      isSuccess
                          ? Icons.check_rounded
                          : (isFallback ? Icons.warning_amber_rounded : Icons.error_outline_rounded),
                      size: 14,
                      color: statusColor,
                    ),
                  ),
                  title: Text(
                    '${log.eventType} (${log.widgetType})',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Outcome: ${log.outcome} ${log.reasonCode != null ? "• Code: ${log.reasonCode}" : ""} • ${log.durationMs}ms',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Text(
                    'CID: ${log.correlationId}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
