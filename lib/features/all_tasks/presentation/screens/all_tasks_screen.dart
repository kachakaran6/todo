import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/core/widgets/quick_theme_sheet.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_quick_add.dart';

/// All Tasks screen — complete, searchable task inventory.
class AllTasksScreen extends ConsumerStatefulWidget {
  const AllTasksScreen({super.key});

  @override
  ConsumerState<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends ConsumerState<AllTasksScreen> {
  String _searchQuery = '';
  bool _isSearching = false;
  final _searchController = TextEditingController();
  _FilterState _filter = const _FilterState();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchBar() : _buildDefaultBar(),
      body: Column(
        children: [
          // Filter chips row
          _FilterBar(
            filter: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: _TaskList(
              searchQuery: _searchQuery,
              filter: _filter,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAdd(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
        heroTag: 'all_tasks_fab',
      ),
    );
  }

  AppBar _buildDefaultBar() {
    return AppBar(
      title: const Text('All Tasks'),
      actions: [
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Theme & Accent',
          onPressed: () => showQuickThemeSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'Search',
          onPressed: () => setState(() => _isSearching = true),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          tooltip: 'Filter',
          onPressed: () => _showFilterSheet(),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }

  AppBar _buildSearchBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => setState(() {
          _isSearching = false;
          _searchQuery = '';
          _searchController.clear();
        }),
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search tasks…',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
        ),
        onChanged: (q) => setState(() => _searchQuery = q),
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () => setState(() {
              _searchQuery = '';
              _searchController.clear();
            }),
          ),
      ],
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<_FilterState>(
      context: context,
      builder: (ctx) => _FilterSheet(current: _filter),
    ).then((result) {
      if (result != null) setState(() => _filter = result);
    });
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Task list (search or browse)
// ──────────────────────────────────────────────────────────────────────────

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.searchQuery, required this.filter});
  final String searchQuery;
  final _FilterState filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchQuery.isNotEmpty) {
      return _SearchResults(query: searchQuery);
    }

    final tasksAsync = ref.watch(allActiveTasksProvider);
    return tasksAsync.when(
      data: (tasks) {
        final filtered = _applyFilter(tasks, filter);
        if (filtered.isEmpty) {
          return searchQuery.isEmpty
              ? const AllTasksEmptyState()
              : SearchEmptyState(query: searchQuery);
        }
        return _buildList(context, ref, filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  List<TaskEntity> _applyFilter(List<TaskEntity> tasks, _FilterState filter) {
    var result = tasks;
    if (!filter.showCompleted) {
      result = result.where((t) => !t.isCompleted).toList();
    }
    if (filter.priorityFilter != null) {
      result = result.where((t) => t.priority == filter.priorityFilter).toList();
    }
    return result;
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<TaskEntity> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        final task = tasks[i];
        return TaskTile(
          key: ValueKey(task.id),
          task: task,
          showProject: true,
          onComplete: () => ref
              .read(taskActionsProvider.notifier)
              .toggleCompleted(task.id, completed: !task.isCompleted),
          onArchive: () => ref
              .read(taskActionsProvider.notifier)
              .archiveTask(task.id),
          onTap: () => context.push('/task/${task.id}'),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 20), duration: 200.ms);
      },
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(taskSearchResultsProvider(query));
    return resultsAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) return SearchEmptyState(query: query);
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: tasks.length,
          itemBuilder: (ctx, i) {
            final task = tasks[i];
            return TaskTile(
              key: ValueKey(task.id),
              task: task,
              showProject: true,
              onComplete: () => ref
                  .read(taskActionsProvider.notifier)
                  .toggleCompleted(task.id, completed: !task.isCompleted),
              onArchive: () =>
                  ref.read(taskActionsProvider.notifier).archiveTask(task.id),
              onTap: () => context.push('/task/${task.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Filter bar
// ──────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.filter, required this.onChanged});
  final _FilterState filter;
  final ValueChanged<_FilterState> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space4,
        vertical: AppConstants.space2,
      ),
      child: Row(
        spacing: AppConstants.space2,
        children: [
          FilterChip(
            label: const Text('Show completed'),
            selected: filter.showCompleted,
            onSelected: (v) => onChanged(filter.copyWith(showCompleted: v)),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Filter sheet
// ──────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.current});
  final _FilterState current;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _FilterState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppConstants.space4),
          SwitchListTile(
            title: const Text('Show completed tasks'),
            value: _state.showCompleted,
            onChanged: (v) => setState(() => _state = _state.copyWith(showCompleted: v)),
          ),
          const SizedBox(height: AppConstants.space4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _state = const _FilterState()),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: AppConstants.space3),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, _state),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Filter state
// ──────────────────────────────────────────────────────────────────────────

class _FilterState {
  const _FilterState({
    this.showCompleted = false,
    this.priorityFilter,
  });

  final bool showCompleted;
  final dynamic priorityFilter;

  _FilterState copyWith({bool? showCompleted, dynamic priorityFilter}) {
    return _FilterState(
      showCompleted: showCompleted ?? this.showCompleted,
      priorityFilter: priorityFilter ?? this.priorityFilter,
    );
  }
}
