import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Empty state widget for various screens.
/// Uses icon + headline + body + optional CTA.
/// No stock illustrations — uses Material icons with themed colors.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.headline,
    required this.body,
    this.ctaLabel,
    this.onCta,
    this.iconSize = 64,
  });

  final IconData icon;
  final String headline;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container with subtle background
            Container(
              width: iconSize + 32,
              height: iconSize + 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withOpacity(0.5),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppConstants.space6),
            // Headline
            Text(
              headline,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.space2),
            // Body
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: AppConstants.space6),
              FilledButton(
                onPressed: onCta,
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Pre-built empty states for each screen
// ──────────────────────────────────────────────────────────────────────────

class InboxEmptyState extends StatelessWidget {
  const InboxEmptyState({super.key, this.onAdd});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
        icon: Icons.inbox_outlined,
        headline: 'Inbox is clear',
        body: 'Capture anything on your mind here. You can sort and file it later.',
        ctaLabel: onAdd != null ? 'Add a task' : null,
        onCta: onAdd,
      );
}

class TodayEmptyState extends StatelessWidget {
  const TodayEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const EmptyStateWidget(
        icon: Icons.wb_sunny_outlined,
        headline: 'Nothing due today',
        body: "You're all caught up. Enjoy the moment.",
      );
}

class ProjectEmptyState extends StatelessWidget {
  const ProjectEmptyState({super.key, this.onAdd});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
        icon: Icons.checklist_outlined,
        headline: 'No tasks yet',
        body: 'Add your first task to get this project moving.',
        ctaLabel: onAdd != null ? 'Add a task' : null,
        onCta: onAdd,
      );
}

class AllTasksEmptyState extends StatelessWidget {
  const AllTasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const EmptyStateWidget(
        icon: Icons.fact_check_outlined,
        headline: 'All clear',
        body: 'Every task is done or archived. A rare and beautiful sight.',
      );
}

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key, required this.query});
  final String query;

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
        icon: Icons.search_off_rounded,
        headline: 'No results',
        body: 'Nothing matched "$query". Try different keywords.',
      );
}

class CompletedEmptyState extends StatelessWidget {
  const CompletedEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const EmptyStateWidget(
        icon: Icons.check_circle_outline_rounded,
        headline: 'Nothing completed yet',
        body: 'Completed tasks will appear here for reference.',
      );
}

class ProjectsListEmptyState extends StatelessWidget {
  const ProjectsListEmptyState({super.key, this.onAdd});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
        icon: Icons.folder_open_rounded,
        headline: 'No projects yet',
        body: 'Group your tasks into projects to stay organized.',
        ctaLabel: onAdd != null ? 'Create a project' : null,
        onCta: onAdd,
      );
}
