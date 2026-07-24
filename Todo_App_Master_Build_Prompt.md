# Master Build Prompt — **Orbit Todo**

> **Copy this entire document into your preferred coding assistant or share it with a Flutter developer.**

---

## 1. Your Role and Mission

You are a senior Flutter product engineer, interaction designer, and performance specialist. Build a production-quality, offline-first to-do application named **Orbit Todo** (the name can be changed later). The familiar task-list concept must feel exceptionally polished, personal, fast, and intentional—**not like a generic template or an AI-generated demo**.

The product serves two audiences without splitting them into separate apps:

1. **Everyday users** need to capture tasks instantly, see what matters today, and complete work with almost no learning curve.
2. **Power users** need a configurable system: flexible views, filters, smart lists, keyboard shortcuts, natural-language capture, task metadata, recurring schedules, automations, and granular preferences.

The product principle is: **“Simple by default. Deep by choice.”** Keep the first-run experience calm and obvious. Progressive disclosure must reveal advanced capability only when a user asks for it.

Build for **Android and iOS** with Flutter. The app is local-first and should remain fully functional without an account or network connection.

---

## 2. Non-Negotiable Product Requirements

### Core task actions

Implement excellent add, view, edit, complete/reopen, duplicate, archive, restore, and permanent-delete flows. A task supports:

- Title (required)
- Optional notes with rich plain-text formatting shortcuts where practical
- Completion state and completion timestamp
- Due date and optional time
- Start date / “do not show before” date
- Reminders and alarms
- Priority: none, low, medium, high, urgent
- Project/list
- Tags/labels
- Subtasks with progress indicator
- Recurrence rules
- Attachments or links (design the data model now; a polished first version can support links first)
- Estimated duration
- Custom fields (for power users)
- Created, updated, and last-opened timestamps

Use soft delete / archive behavior before permanent deletion. Undo must appear after destructive actions. Design deletion confirmation intelligently: no confirmation for an undoable swipe action; confirm permanent deletion and irreversible batch actions.

### Essential views

Create these primary sections:

- **Inbox** — rapid capture; unprocessed tasks.
- **Today** — work that is due today, scheduled for today, overdue, and optionally “next actions.” Group clearly by urgency/time.
- **Upcoming** — a timeline/calendar-focused view for the next days and weeks.
- **Projects** — user-created lists/projects with task counts and optional colors/icons.
- **All Tasks** — searchable complete inventory with sophisticated filter/sort/group controls.
- **Completed / Archive** — a clean historical area with restore capability.

Add **Smart Lists**: saved combinations of filters such as `High priority`, `Overdue`, `No due date`, `Work`, or a custom query. Ship a few useful default Smart Lists but let users edit, reorder, hide, or create their own.

### Task capture

Task creation must be extraordinarily quick:

- Persistent floating add button on phone layouts, accessible command on tablet/desktop layouts.
- A compact quick-add sheet that accepts a title immediately and expands only if the user needs detail.
- Natural-language parsing, but never silently destructive. Example: `Send invoice tomorrow at 9am #work !high` should suggest/parse a date, time, tag, and priority. Show visually what was recognized, allow correction, and preserve words that cannot be parsed.
- Add task through share intent where supported.
- Optional voice capture can be planned as a future capability, but do not block v1 on it.

---

## 3. Experience and Visual Direction

### Design personality

Aim for **editorial calm with moments of delightful motion**, not visual noise. It should feel like a crafted premium utility: confident typography, generous spacing, meaningful iconography, tactile completion feedback, and empty states with personality. Avoid excessive gradients, glassmorphism, neon colors, random animation, stock illustrations, oversized rounded cards everywhere, and “dashboard” clutter.

Use Material 3 foundations thoughtfully, but do not leave default Flutter styling untouched. Create a coherent design system with custom tokens and reusable components.

### Layout and navigation

- **Phones:** bottom navigation for the 4–5 highest-value destinations, plus an adaptive top app bar. Projects and settings can live behind a clear navigation affordance. Do not overload the bottom bar.
- **Tablets / desktop:** responsive navigation rail or side bar; multi-pane task details where space allows.
- Support compact, medium, and expanded responsive breakpoints with intentional layouts—not merely stretched phone screens.
- Use Flutter’s standard back handling correctly: back closes an open task editor, search, filters, modal sheets, drawer, or selection mode before leaving the route. From root destinations, use platform-appropriate exit behavior. Do not trap users in a back-navigation loop.
- Every screen must have considered loading, empty, populated, error, and offline states.

### Themes and accent colors

Implement system, light, and dark modes. Theme changes must apply immediately and persist locally.

Provide five hand-tuned accent themes that meet contrast requirements in both light and dark modes:

1. **Indigo** — composed default
2. **Emerald** — fresh and grounded
3. **Coral** — warm and energetic
4. **Amber** — optimistic and focused
5. **Violet** — expressive and premium

Do not simply replace one seed color everywhere. Define semantic color tokens per theme: primary, on-primary, surface, surface-container, outline, destructive, warning, success, priority indicators, and selection state. Verify contrast for small text, disabled elements, chips, icons, and selected controls.

### Motion and haptics

Motion should clarify state changes:

- Task completion has a fast satisfying check/strike-through transition and subtle haptic feedback when supported.
- Reordering, filtering, task expansion, and navigation use short, consistent transitions.
- Respect “reduce motion” / accessible-navigation platform preferences.
- Never delay interaction for animation.

### Accessibility

Treat accessibility as a feature, not a checkbox:

- Screen-reader labels, hints, semantic roles, and state announcements.
- Full keyboard navigation and visible focus treatment for hardware keyboard users.
- Logical focus order in sheets/dialogs.
- Dynamic text scaling without overflow.
- Touch targets at least 44–48 logical pixels.
- No color-only status indicators; pair them with icon/text/shape.
- Respect platform contrast, reduced motion, and text-scale preferences.

---

## 4. Power-User Customization

Keep these features discoverable in a dedicated **Customize** area and contextual menus, rather than crowding basic task creation.

Implement:

- Reorderable / hideable navigation items and home sections.
- Custom Smart Lists from a visual filter builder, including AND/OR groups where feasible.
- Saved sort/group combinations: by due date, priority, project, tag, creation date, completion date, or manual order.
- User-selectable default landing page and default quick-add project.
- Configurable swipe actions (e.g., complete, schedule, priority, archive).
- Configurable task density: comfortable, compact, and spacious.
- Advanced task fields that users may toggle on/off.
- Custom field definitions: text, number, checkbox, single select, multi-select, date. Store definition and values locally with validation.
- A command palette on desktop/web-capable layouts and optionally mobile: create task, search, jump to project, toggle theme, open settings.
- A keyboard-shortcut reference that adapts to available controls.
- Batch selection: complete, reschedule, move, tag, prioritize, archive/delete.

Use progressive disclosure. A new user should be able to add and complete a task without ever encountering query builders or custom fields.

---

## 5. Calendar, Reminders, and Widgets

### Calendar integration

Implement calendar functionality in two layers:

1. A beautiful **in-app calendar**: month and agenda/week modes, task dots/counts, and a day agenda. It must stay fast for long task histories.
2. Optional **device calendar integration** through explicit permission and user-controlled behavior. At minimum, allow exporting a task to a chosen device calendar. If two-way sync is not reliable in v1, do not pretend it is; label one-way behavior plainly and design a durable sync boundary for later.

### Reminders and alarms

- A task may have one or more reminders.
- Schedule reliable local notifications for reminders, including correct timezone/DST behavior.
- Provide clear permission onboarding only at the moment the feature is used; do not request notification permission on the first launch without context.
- Android: use high-importance notification channels and exact alarm permission only if truly needed. Explain why before sending users to system settings.
- iOS: use local notification APIs and document system limitations accurately.
- Tapping a notification must deep-link to the exact task and provide fast complete/snooze actions where platform support permits.
- Handle reboot/timezone/app upgrade reconciliation so future alarms are rescheduled safely.

### Home-screen widgets

Add widget support with a small, reliable scope:

- Small widget: next most important task / quick-add launch.
- Medium widget: Today list with completion count and next tasks.
- Optional large widget: Today plus upcoming.
- Widgets refresh on meaningful local changes and at sensible scheduled intervals while respecting platform limits/battery.
- Tapping a widget item opens the corresponding task. Ensure widget content is accessible and theme-aware.

Use a Flutter-compatible widget solution that supports both platforms, while isolating native bridge code behind a clean adapter.

---

## 6. Engineering Architecture

Use a maintainable, testable, feature-first architecture. Prefer stable, well-maintained packages and avoid dependency sprawl. Pin compatible versions and document every selected package’s role in the README.

### Recommended stack

- **Flutter:** current stable channel; Dart with sound null safety.
- **State management:** `flutter_riverpod` / Riverpod with code generation where it makes the model safer and less repetitive. Keep UI state distinct from domain data.
- **Local persistence:** Drift (SQLite) for relational, queryable, durable task data. Enable migrations and transactional writes. Use a lightweight preferences store such as `shared_preferences` or `flutter_secure_storage` only for appropriate settings/secrets—not primary task data.
- **Navigation:** `go_router` with typed, deep-linkable routes and proper browser/history behavior if web later becomes a target.
- **Notifications:** a mature local-notifications package, wrapped behind a `ReminderService` interface.
- **Time/date:** `timezone` plus a robust date/time formatting strategy. All instants should be stored consistently; preserve local date-only semantics for all-day tasks.
- **Widgets:** a maintained home-screen widget package, isolated through `WidgetService`.
- **Calendar permissions:** a mature calendar/event integration package, behind `CalendarService`.
- **Animations:** native Flutter implicit/explicit animations first; use a focused library only for advanced effects.
- **Icons:** a consistent icon set and custom app icon assets. Avoid mixing unrelated icon styles.

Before finalizing dependencies, verify they are actively maintained, compatible with the selected Flutter version, and have appropriate platform support. Do not use abandoned packages merely because they are convenient.

### Layer boundaries

Organize by feature, with clear layers:

```text
lib/
  app/                 # app shell, routes, global theme
  core/                # errors, utilities, shared tokens, platform adapters
  features/
    tasks/             # domain, data, application, presentation
    projects/
    smart_lists/
    calendar/
    reminders/
    settings/
    widgets/
  data/local/          # Drift database, schema, migrations
```

Within each feature, keep domain entities/use cases independent from Flutter widgets and database details. Use repositories/interfaces so later cloud sync is an addition, not a rewrite. Prefer immutable models, explicit result/error handling, and injectable services.

### Data model minimum

Model the following as first-class data, with stable IDs and audit timestamps:

- `Task`, `Project`, `Tag`, `Subtask`, `Reminder`, `RecurrenceRule`, `AttachmentLink`
- `SmartList` / serialized filter definition
- `CustomFieldDefinition` and `CustomFieldValue`
- `UserPreferences`
- Optional `TaskActivity` event log for undo/history and a future sync engine

Use normalized tables and indexes for common queries: incomplete tasks by due/start date, tasks by project/tag, full-text/title search strategy, reminders by next fire time, and completed/archived tasks. Keep the recurrence system as a rule plus occurrence calculation; do not eagerly create thousands of future task rows.

### Recurrence rules

Support daily, weekly, monthly, yearly, interval-based recurrence, selected weekdays, and an end date/count. Completing a recurring task must create/advance the next instance safely without duplicating items when the user taps twice or the app restarts. Clearly define behavior for overdue recurring tasks and edits to “this task” vs “this and future tasks.” Begin with a sensible subset if needed, but make rule storage extensible.

---

## 7. Performance: This Must Feel Instant

The app’s signature is speed. Target fast perceived and measurable performance on mid-range devices.

- Open directly to cached local content; no blocking splash logic beyond essential initialization.
- Keep database work off the UI isolate where needed; batch writes and use transactions.
- Query only the records required for each screen. Never load all tasks into memory to render Today.
- Use pagination/windowing for All Tasks, Archive, search results, and long projects.
- Use `ListView.builder`/slivers, stable keys, selective Riverpod rebuilds, `const` widgets, and repaint boundaries where profiling supports them.
- Debounce search and filter input; cancel obsolete work.
- Maintain indexes and inspect query plans for high-volume views.
- Avoid expensive layout nesting, unnecessary blur, continuous animations, and automatic eager image processing.
- Test with 10,000+ tasks, thousands of completed tasks, nested subtasks, recurring tasks, and many tags/projects.
- Establish performance targets: quick-add interaction feels immediate; list scroll remains smooth; Today opens from warm state in under ~300 ms on a representative mid-range device; typical database mutations complete without visible stutter.
- Profile in release/profile mode, not only debug mode. Document before/after findings for any optimization made.

---

## 8. Reliability, Privacy, and Quality

### Offline and privacy

- The application is fully usable offline and stores user data locally by default.
- No analytics, account, tracking, or network dependency should be silently introduced.
- If telemetry is later added, make it opt-in, privacy-conscious, and clearly explained.
- Include export/import early: JSON for complete structured backup; optionally CSV for task portability. Validate imports and show a dry-run summary before modifying data.
- Include a data deletion path and explain exactly what is erased.

### Error handling

Do not expose raw exceptions to users. Use concise human language, recovery actions, and logging appropriate for development builds. Safely handle malformed imports, permission denial, notification scheduling errors, interrupted migrations, duplicate taps, daylight-saving transitions, and app termination during an edit.

### Testing

Create meaningful tests—not only widget smoke tests:

- Unit tests for task use cases, recurrence calculation, date/time parsing, filtering, and migrations.
- Repository/database integration tests for transactions, indexes, archive/restore, and queries.
- Widget tests for quick add, task editor validation, theme changes, accessibility semantics, and back behavior.
- End-to-end tests for onboarding, create/edit/complete, recurrence, reminders, calendar export, import/export, and major navigation paths.
- Golden tests for core screens in light/dark themes and all five accents.
- Manual test matrix for Android/iOS notifications, system theme changes, orientation, text scaling, platform back gestures, widgets, device calendar permissions, and fresh-install/upgrade migrations.

Run static analysis with strict lints, format all code, and keep the analyzer clean. Add CI to run analysis, tests, and build checks on pull requests.

---

## 9. In-App Review and Update Behavior

### In-app review

Use the platform’s native review prompt API. Never show it on first launch, after an error, or right after a user is interrupted. Qualify a user after a genuinely positive moment, such as completing a meaningful number of tasks across several days. Track prompts locally, honor platform limits, and provide a Settings option to rate the app manually.

### In-app updates

On Android, integrate the official in-app update mechanism where Play-distributed builds support it. Use flexible updates by default; reserve immediate updates for critical compatibility/security releases. On iOS, do not simulate an unsupported forced update flow—show a graceful “Update available” notice with an App Store link when appropriate. Ensure every update state has a dismiss/retry path and never blocks access to locally stored tasks unless a critical data migration truly requires it.

---

## 10. Delivery Plan

Build in incremental, demoable phases. Do not begin with every advanced feature.

### Phase 1 — Exceptional core

- Design tokens, responsive app shell, theme system, five accents
- Drift database and migrations foundation
- Inbox, Today, Projects, task create/edit/complete/archive/delete/undo
- Search, basic filters, subtasks, priorities, due dates
- High-quality empty states, accessibility, back navigation, tests

### Phase 2 — Planning power

- Upcoming and in-app calendar
- Tags, Smart Lists, saved views, batch actions
- Recurrence and advanced scheduling
- Natural-language quick add
- Customization controls and keyboard support

### Phase 3 — Device integration

- Local reminders/alarms with robust rescheduling
- Calendar export/integration
- Android/iOS home-screen widgets
- Import/export/backup
- In-app review and update handling

### Phase 4 — Polish and hardening

- Performance profiling against large data sets
- Golden/E2E coverage, upgrade/migration testing
- Accessibility audit
- Store readiness: app icon, screenshots, privacy policy copy, release notes

At the end of each phase, provide a short changelog, known limitations, test results, and a list of the next highest-risk items.

---

## 11. Definition of Done / Acceptance Checklist

A feature is only done when it is visually refined, accessible, tested, persistent through app restart, and behaves correctly in both light and dark themes.

The release candidate must demonstrate that:

- A first-time user can add, schedule, complete, and find a task within seconds.
- A power user can build a personalized workspace without making the default UI confusing.
- All task changes persist locally and survive restart, app update, and device timezone change where applicable.
- Back gestures and the system back action close the correct UI layer before navigation.
- Every one of the five accent themes is deliberate, readable, and beautiful in light/dark mode.
- Today, search, and long lists remain responsive with a large local dataset.
- Reminders, calendar actions, widgets, review prompts, and updates fail gracefully when permissions, platform capability, or network are unavailable.
- The product contains no placeholder copy, broken interactions, generic unstyled widgets, fake sync claims, or AI-sounding marketing text.
- Code is clean, documented where decisions are non-obvious, analyzed, formatted, and covered by appropriate tests.

---

## 12. Final Implementation Output Required

Deliver:

1. A working Flutter application for Android and iOS.
2. A concise `README.md` covering setup, architecture, dependencies, configuration, running tests, builds, permissions, and platform caveats.
3. A database schema/migration note and a clear future cloud-sync extension plan.
4. A design-system reference: colors, typography, spacing, elevations, components, states, and motion rules.
5. Test coverage summary and manual QA checklist.
6. A short product decision log describing key trade-offs (especially recurrence, notification behavior, calendar sync scope, and widget limitations).

Make thoughtful decisions when requirements conflict. Favor reliability, clarity, perceived speed, and native-feeling behavior over feature count. Build a to-do app that users trust enough to put their life into—a tiny orbit of calm in a noisy day.
