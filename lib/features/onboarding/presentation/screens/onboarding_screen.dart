import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/features/settings/application/preferences_provider.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_priority.dart';

/// Guided 4-step Onboarding screen (PRD Section 8.1).
/// First task creation is friction-free and completes under 60 seconds.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final TextEditingController _taskController = TextEditingController();
  int _selectedPriority = 0;
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final title = _taskController.text.trim();
    if (title.isNotEmpty) {
      await ref.read(taskActionsProvider.notifier).createTask(
            title: title,
            priority: _selectedPriority,
            dueDate: _selectedDueDate,
          );
    }
    await ref.read(preferencesNotifierProvider.notifier).completeFirstRun();
    if (mounted) {
      context.go('/today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.space5),
          child: Column(
            children: [
              // Top Progress Indicator
              Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: 300.ms,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _step
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstants.space6),

              // Dynamic Step View
              Expanded(
                child: AnimatedSwitcher(
                  duration: 300.ms,
                  child: switch (_step) {
                    0 => _StepWelcome(
                        onStart: () => setState(() => _step = 1),
                        onExplore: _completeOnboarding,
                      ),
                    1 => _StepCreateTask(
                        controller: _taskController,
                        onNext: () {
                          if (_taskController.text.trim().isNotEmpty) {
                            setState(() => _step = 2);
                          }
                        },
                      ),
                    2 => _StepSchedule(
                        priority: _selectedPriority,
                        dueDate: _selectedDueDate,
                        onPriorityChanged: (p) => setState(() => _selectedPriority = p),
                        onDateChanged: (d) => setState(() => _selectedDueDate = d),
                        onNext: () => setState(() => _step = 3),
                      ),
                    _ => _StepComplete(onFinish: _completeOnboarding),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepWelcome extends StatelessWidget {
  const _StepWelcome({required this.onStart, required this.onExplore});
  final VoidCallback onStart;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.wb_sunny_rounded,
            size: 44,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: AppConstants.space5),
        Text(
          'TaskMitra',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppConstants.space2),
        Text(
          'Simple by default, deep by choice.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onStart,
            child: const Text('Get Started', style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(height: AppConstants.space3),
        TextButton(
          onPressed: onExplore,
          child: const Text('Explore First'),
        ),
      ],
    );
  }
}

class _StepCreateTask extends StatelessWidget {
  const _StepCreateTask({required this.controller, required this.onNext});
  final TextEditingController controller;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is one thing you need to do today?',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppConstants.space4),
        TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Finish project proposal',
            prefixIcon: const Icon(Icons.check_circle_outline_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onSubmitted: (_) => onNext(),
        ),
        SizedBox(height: AppConstants.space4),
        Wrap(
          spacing: 8,
          children: [
            'Review email inbox',
            'Plan weekly goals',
            'Buy groceries',
          ].map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () {
                controller.text = suggestion;
              },
            );
          }).toList(),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onNext,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class _StepSchedule extends StatelessWidget {
  const _StepSchedule({
    required this.priority,
    required this.dueDate,
    required this.onPriorityChanged,
    required this.onDateChanged,
    required this.onNext,
  });

  final int priority;
  final DateTime? dueDate;
  final ValueChanged<int> onPriorityChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppConstants.space4),
        Text(
          'Add Optional Details',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppConstants.space2),
        Text(
          'You can set a due date or priority now, or skip and set it later.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppConstants.space6),

        // Priority Selector
        Text('PRIORITY', style: theme.textTheme.labelSmall),
        SizedBox(height: AppConstants.space2),
        Row(
          children: [0, 1, 2, 3].map((p) {
            final labels = ['None', 'Low', 'Medium', 'High'];
            final isSelected = priority == p;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(labels[p]),
                  selected: isSelected,
                  onSelected: (_) => onPriorityChanged(p),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: AppConstants.space6),

        // Due Date Selector
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tileColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          leading: const Icon(Icons.calendar_today_rounded),
          title: Text(dueDate == null ? 'Set Due Date' : 'Due: ${_formatDate(dueDate!)}'),
          trailing: dueDate != null
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () => onDateChanged(null),
                )
              : null,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) onDateChanged(picked);
          },
        ),

        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onNext,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _StepComplete extends StatelessWidget {
  const _StepComplete({required this.onFinish});
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: AppConstants.space5),
        Text(
          'You are all set!',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppConstants.space2),
        Text(
          'Your space is ready. Start building momentum one task at a time.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onFinish,
            child: const Text('Open Today'),
          ),
        ),
      ],
    );
  }
}
