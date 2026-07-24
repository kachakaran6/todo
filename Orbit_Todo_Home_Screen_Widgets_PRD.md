# Product Requirements Document
# Orbit Todo — Professional Home-Screen Widgets

**Document type:** Focused feature PRD  
**Product:** Orbit Todo  
**Status:** Ready for design and implementation  
**Primary platform:** Android (first release), with an iOS WidgetKit parity plan  
**Product principle:** A widget must always look intentional. It must never expose raw exceptions, blank broken layouts, stale placeholder data, or technical error messages to the user.

---

## 1. Purpose

Orbit Todo’s home-screen widgets provide a fast, trustworthy glance at the user’s work and a direct path to action without opening the app. They must feel native to the operating system, match the app’s visual language, remain useful under imperfect conditions, and fail gracefully when data, permissions, or background refresh are unavailable.

This PRD defines the widget product experience, supported widget families, visual requirements, data and refresh behavior, error-proof states, observability/logging, quality assurance, and release acceptance criteria.

---

## 2. Goals

1. Let users see the most relevant tasks in one glance.
2. Let users complete, add, or open tasks with the fewest reliable interactions possible.
3. Ensure every widget state is deliberate, understandable, and visually polished.
4. Keep widget loads fast and battery-conscious.
5. Make the widget dependable without requiring account sign-in or a network connection.
6. Provide developers with structured logs that identify failures before users encounter them.

### Success metrics

- Widget content is visible after device restart and app update without manual repair in **99.5%+** of tested cases.
- A valid widget render completes from local data in **under 300 ms** on a representative mid-range Android device.
- Widget tap-to-app navigation succeeds in **99.9%+** of automated and manual release tests.
- No raw error copy, stack trace, platform exception, empty white/black frame, or permanently loading state is user-visible.
- Widget action failures are recoverable and do not destroy, duplicate, or incorrectly complete a task.

---

## 3. Scope

### In scope

- Android App Widgets built with modern native widget tooling and shared Flutter data access.
- iOS WidgetKit requirements and parity guidance.
- Four production widget types: Today, Quick Add, Inbox, and Focus.
- Small, medium, and large responsive layouts where supported by the platform.
- Local-first task data snapshots for widget rendering.
- Completion, open-app, and quick-add entry actions.
- Widget configuration, loading, empty, unavailable, and recovery states.
- Structured development and production-safe diagnostics.
- Automated tests, manual test scenarios, and release gates.

### Out of scope for this release

- Editable task text directly inside a widget.
- Drag-and-drop task ordering from the launcher.
- Full calendar month widgets.
- Remote/cloud-backed widget content as a requirement.
- Ads, promotions, upsells, or premium paywalls inside widgets.

---

## 4. Experience Principles

### 4.1 Glanceable, not miniature app screens
A widget presents only information that can be understood in seconds. It must not compress a full task manager into tiny cards, dense controls, or unreadable labels.

### 4.2 One clear primary job per widget
Each widget has a named purpose and a focused interaction model. A widget should not combine unrelated lists, settings shortcuts, marketing, and calendar details.

### 4.3 Native first, Orbit second
Respect Android and iOS widget constraints, typography, safe areas, dynamic sizing, touch target rules, and system color behavior. Orbit branding should be subtle and never fight the home screen.

### 4.4 Calm density
Use the established Orbit spacing scale. Do not manufacture empty space, but preserve adequate breathing room around text, check controls, and edge boundaries. Content must be compact without feeling cramped.

### 4.5 Local data is the source of truth
Widgets read a safe, precomputed local snapshot. They must remain useful offline and must never depend on a network request to display the core task list.

### 4.6 Graceful imperfection
A temporarily unavailable or out-of-date widget should communicate that simply and offer a practical recovery action. It must never show technical details to the user.

---

## 5. Supported Widget Catalog

| Widget | Primary job | Recommended sizes | Core actions |
|---|---|---|---|
| **Today** | Show what is due or planned today | Small, medium, large | Open Today, complete task, open task |
| **Quick Add** | Capture a task immediately | Small, medium | Add task, open Inbox/Quick Add |
| **Inbox** | Surface untriaged tasks | Medium, large | Open Inbox, complete task, open task |
| **Focus** | Keep one chosen task visible | Small, medium | Complete focus task, choose/open focus task |

Users may add multiple instances of each widget. Each instance stores independent configuration; for example, one Today widget may show Work tasks while another shows Personal tasks.

---

## 6. Shared Widget Anatomy and Visual System

### 6.1 Shared anatomy
Every list-based widget follows the same hierarchy:

1. **Header:** concise widget title and optional compact context, such as “Tue, 25 Jul”.
2. **Content:** tasks or purpose-specific action.
3. **Footer/action affordance:** only when meaningful for the widget size.
4. **Status treatment:** reserved for loading, empty, unavailable, or refresh status—not normal operation.

### 6.2 Visual rules

- Use the app’s active light/dark appearance when platform support permits.
- Respect the user’s selected Orbit accent color: Indigo, Teal, Coral, Amber, or Violet.
- Use semantic colors for completion, overdue status, and disabled controls; do not rely on color alone.
- Use the app’s configured font selection only where the platform supports it safely. If unsupported, use the native platform system font rather than a broken or fallback-looking custom font.
- Maintain a minimum **44 × 44 pt** touch target on iOS and **48 × 48 dp** on Android for actionable targets where layout allows.
- Do not use more than two text weights per widget surface.
- Never truncate the only meaningful word of a task title. Prefer two lines in large layouts, a sensible ellipsis in constrained layouts, and full title in the app on tap.
- Avoid heavy shadows, gradients that reduce contrast, decorative illustrations, and generic AI-like visual clutter.

### 6.3 Layout sizing behavior

| Size | Content priority |
|---|---|
| **Small** | One primary fact/action; at most one task title and one completion action |
| **Medium** | Header plus up to three tasks, or a primary action with helpful context |
| **Large** | Header, date/context, up to six tasks, and a compact “Open Orbit” affordance |

Do not rely solely on device category. Use actual widget dimensions and responsive breakpoints. If the launcher reports an unsupported or unusually narrow size, render the smallest stable layout rather than clipping content.

---

## 7. Detailed Widget Requirements

### 7.1 Today Widget

**User value:** “Show me what matters today without making me think.”

#### Content logic

1. Incomplete tasks due today, sorted by user-defined task order.
2. Incomplete scheduled-but-not-due-today tasks that the user has explicitly configured to appear in Today.
3. Overdue incomplete tasks, grouped after today tasks, up to the widget capacity.
4. Exclude archived, deleted, hidden, and completed tasks.
5. Respect the widget instance’s optional list/project filter.

#### Layouts

- **Small:** title, total remaining count, one next task title, completion control.
- **Medium:** title/date, up to three task rows, one compact open button.
- **Large:** title/date, up to six task rows, a visually distinct overdue grouping only when needed.

#### Interaction rules

- Tapping the header opens Today in the app.
- Tapping a task title opens that task in its detail view.
- Tapping completion toggles the task complete state through the safe action pipeline.
- If no eligible tasks remain, update immediately to the intentional empty state.

### 7.2 Quick Add Widget

**User value:** “Capture a thought before it disappears.”

#### Layouts

- **Small:** one large “Add task” action and subtle Inbox context.
- **Medium:** “Add task” action plus the most recent Inbox task or a short helper phrase.

#### Interaction rules

- A tap opens the app directly to a focused quick-add composer.
- The composer must be ready for input within the app’s defined warm-start target.
- The widget itself must not pretend to support inline text entry if platform reliability is inconsistent.
- After saving, return the user to the appropriate app context and refresh all affected widgets.

### 7.3 Inbox Widget

**User value:** “Keep incoming tasks visible until I clarify them.”

#### Content logic

- Show active Inbox tasks with no project/list assignment first.
- Sort by user-selected Inbox ordering; default to oldest first.
- A widget instance may be configured to show all Inbox items or a selected capture list.

#### Layouts

- **Medium:** header, up to three tasks, add action.
- **Large:** header, count, up to six tasks, add action, open Inbox action.

### 7.4 Focus Widget

**User value:** “Keep one meaningful task front and center.”

#### Content logic

- Use an explicitly pinned focus task when set.
- Otherwise use the user’s top incomplete Today task.
- If neither exists, show the configured no-focus state.

#### Layouts

- **Small:** focus label, task title, large completion control.
- **Medium:** focus label, task title, optional due label, complete and “Open” actions.

#### Interaction rules

- Completing the focus task immediately selects the next eligible focus task or moves to empty state.
- Tapping the task opens its detail page.
- The user can change focus from the app, never through an unreliable launcher-only flow.

---

## 8. Configuration Experience

Widget configuration must take place in Orbit Todo through a clean, dedicated configuration screen, not through a confusing collection of launcher dialogs.

### Required configuration options

- Widget title visibility: automatic or hidden where space allows.
- List/project filter: All tasks or a selected source.
- Maximum task count: automatic based on size; optional compact preference for larger widgets.
- Show overdue tasks: on/off for Today widgets.
- Today context: date only, count only, both, or neither where size allows.
- Focus source: pinned focus task or automatic top Today task.
- Accent treatment: follow app theme (default) or neutral system styling.

### Configuration safeguards

- A configuration change must render a preview before saving.
- Missing/deleted projects or filters must automatically fall back to “All tasks” and present a non-disruptive “Updated” state in the app, not an error on the widget.
- Configuration values must be schema-versioned and migrated during app updates.

---

## 9. Reliability and Error-Proof Widget States

### 9.1 Mandatory rule: no user-visible technical errors

The widget must never display:

- Exception names, error codes, stack traces, JSON, database messages, or platform logs.
- “Null”, “undefined”, “failed”, “crashed”, or unlocalized developer copy.
- A blank container caused by an unhandled rendering state.
- A spinner that remains indefinitely.
- An action that appears successful when it did not safely apply.

### 9.2 Approved user-facing states

| Situation | Widget treatment | Available action |
|---|---|---|
| Initial install / first render | Brief native loading skeleton, maximum 2 seconds when possible | None; automatically resolves |
| No tasks | Purpose-specific empty message, e.g. “Today is clear.” | “Add task” or “Open Orbit” |
| No Focus task | “Choose one thing to focus on.” | “Choose in Orbit” |
| Temporary local snapshot unavailable | “Open Orbit to refresh your tasks.” | Open Orbit |
| Action waiting to be confirmed | Subtle pending completion state for the affected row only | Tap opens app if it persists |
| Configuration is no longer valid | Safe default content; no widget warning | App may show an unobtrusive explanation |
| Widget host is unable to refresh | Continue showing last known valid snapshot with a non-alarming stale indicator only if data age exceeds 24 hours | Open Orbit |

Copy must be short, calm, and specific. Do not blame the user or imply data loss.

### 9.3 Last known good render policy

- Persist a validated, versioned “last known good” widget snapshot separately from transient render data.
- If current data cannot be decoded or calculated, render the last known good snapshot.
- If no valid snapshot exists, render the static empty/onboarding state—not a broken container.
- A failed update must never overwrite a valid prior snapshot.
- Every rendered snapshot includes a creation timestamp, schema version, widget instance ID, and integrity check.

### 9.4 Safe data snapshot pipeline

1. The Flutter app commits a task update to the local database.
2. A background-safe snapshot builder derives the minimal widget model from committed data.
3. Validate the model: required IDs, safe text length, valid dates, nonnegative counts, and supported schema version.
4. Write the snapshot atomically to shared storage available to widget code.
5. Request a widget refresh only after the atomic write succeeds.
6. Widget code reads, validates, and renders the snapshot.
7. On any failure, preserve and render the last known good snapshot or approved fallback state.

Do not make widget code query complex app database tables directly at render time. This avoids lock contention, migration mismatches, and partial-read crashes.

### 9.5 Action safety pipeline

For task completion from a widget:

1. Validate that the widget action includes a current, opaque task identifier and action token.
2. Write the requested action to a small durable action queue before changing display state.
3. Apply the task update transactionally when app/shared storage access permits.
4. Rebuild the snapshot and refresh all relevant widget instances.
5. Remove the queue item only after a successful commit.
6. If the action cannot be safely committed, retain the original task state, log the failure, and provide an app-opening recovery path.

Actions must be idempotent: repeated tap delivery must not create duplicate tasks or toggle completion twice unexpectedly.

### 9.6 Handling common resilience cases

| Scenario | Required behavior |
|---|---|
| App update changes data schema | Migrate snapshot; if migration fails, retain safe fallback and rebuild from app on next launch |
| User changes time zone/date | Recalculate Today and overdue groupings at next refresh and at local midnight |
| Device restarts | Widget reads last known good snapshot without requiring app launch |
| App process is killed | Widget still renders stored snapshot; actions use durable queue/intent handling |
| Task is deleted after widget snapshot | Open task action validates existence and opens the appropriate list/app fallback |
| Task has extremely long or malformed title | Sanitize and safely truncate display text; preserve original text in app |
| Local storage is full/unavailable | Keep existing snapshot; log; app presents recovery guidance on next launch |
| Widget host limit/throttling | Coalesce updates and show last valid data rather than repeatedly retrying |

---

## 10. Refresh and Performance Requirements

### Refresh triggers

Refresh eligible widgets after:

- task creation, edit, completion, uncompletion, deletion, archive, restore;
- due date, recurrence, project/list, focus, or ordering changes;
- widget configuration changes;
- local date rollover at midnight;
- time-zone change;
- application upgrade or snapshot schema migration;
- successful import/restore.

### Refresh rules

- Coalesce burst edits into one refresh request per short debounce window.
- Refresh only widget instances affected by the changed task/configuration where possible.
- Never schedule aggressive periodic refresh solely to imitate real-time updates.
- Respect Android and iOS system refresh policies; last known good data is the fallback.
- Avoid rendering work, database queries, or image processing on the main thread.

### Performance budgets

| Operation | Target |
|---|---|
| Build shared widget snapshot after a normal task change | < 150 ms |
| Render stored widget snapshot | < 300 ms |
| Memory used by one snapshot | < 256 KB typical; hard cap 1 MB |
| Update requests after 20 rapid edits | ≤ 3 coalesced refreshes |
| Startup behavior with 10,000 tasks | No blocking full-database scan on widget render |

---

## 11. Logging, Diagnostics, and Development Observability

Logging is mandatory during development and retained in a privacy-safe form for production diagnosis. Logs help detect widget failures early; they must not become another source of personal data exposure.

### 11.1 Log design requirements

- Use structured events, not ad-hoc print statements.
- Assign a correlation ID to each snapshot build and action request.
- Include widget type, widget instance ID (hashed), platform, app version, schema version, event result, elapsed time, and sanitized reason code.
- Never log task titles, notes, contact details, calendar names, raw task IDs, or full file paths in production logs.
- Use debug-only verbose details; production logs must be sampled, bounded, and privacy-safe.
- Store a local rolling diagnostic buffer, such as the most recent 200 widget events, for developer support/export only when the user opts in.

### 11.2 Required event categories

| Event | Minimum fields |
|---|---|
| Snapshot build started/finished | correlation ID, source trigger, widget types affected, duration, result |
| Snapshot validation failure | schema version, validation rule ID, fallback used |
| Widget render success/failure | widget type, size family, snapshot age, duration, outcome |
| Widget action received | action type, widget type, token validation result |
| Action queue success/failure | action type, retry count, reason code, duration |
| Refresh requested/completed | affected instance count, coalesced count, outcome |
| Configuration migration | prior/new version, outcome, fallback used |
| Recovery/fallback shown | category, last known snapshot availability, snapshot age |

### 11.3 Example reason codes

Use stable, non-user-facing codes such as:

- `WIDGET_SNAPSHOT_MISSING`
- `WIDGET_SNAPSHOT_INVALID_SCHEMA`
- `WIDGET_SNAPSHOT_INTEGRITY_FAILED`
- `WIDGET_ACTION_TOKEN_REJECTED`
- `WIDGET_ACTION_TASK_NOT_FOUND`
- `WIDGET_ACTION_QUEUE_RETRY`
- `WIDGET_RENDER_HOST_CONSTRAINT`
- `WIDGET_STORAGE_WRITE_FAILED`
- `WIDGET_CONFIGURATION_FALLBACK`

### 11.4 Developer debug tooling

Provide an internal debug screen, disabled in release builds by default, with:

- current snapshot inspection with sensitive task content masked;
- snapshot age and schema version;
- active widget instances and configuration summaries;
- recent structured widget events;
- “Rebuild snapshots” action;
- “Simulate missing snapshot”, “simulate invalid schema”, “simulate storage failure”, and “simulate task deleted” test actions;
- copy/export diagnostic report for development and QA.

Debug tooling must never be accessible through a normal user-facing widget action.

### 11.5 Alerting and release monitoring

Before public release, QA and internal builds should flag any of these as blockers:

- any unhandled widget rendering exception;
- fallback shown repeatedly for the same instance without recovery;
- action failure rate above 0.1%;
- snapshot validation failure after a fresh installation or upgrade;
- widget render above the defined performance budget in common test profiles.

---

## 12. Navigation Requirements

- Widget header/action opens Orbit Todo to the exact expected destination.
- Tapping a task opens its detail page only after validating it still exists.
- If a task no longer exists, open the relevant parent view and show a brief, non-technical message in the app: “That task is no longer available.”
- The normal in-app back flow applies after entry from a widget: detail → parent list → Today/home → platform exit behavior.
- Launching from a widget must not create a confusing duplicate stack when Orbit is already open; route or reuse the existing task safely.
- Deep links must work after cold start, warm start, app update, and process restoration.

---

## 13. Accessibility and Localization

- Give each task completion control a meaningful label, e.g. “Mark Buy groceries complete.”
- Expose widget title, task count, status, due/overdue state, and actions to TalkBack/VoiceOver.
- Do not depend only on a colored dot or strikethrough to convey completion/overdue status.
- Support system font scaling without overlapping text or disappearing actions. At very large scale, reduce task count before clipping content.
- Meet contrast requirements in light, dark, and each accent color variation.
- Localize all labels, dates, plural forms, and empty-state messages.
- Test right-to-left layout rendering and text truncation explicitly.

---

## 14. Analytics (Optional and Privacy-Safe)

Analytics must be opt-in where required by platform or regional policy and must never include task content.

Recommended aggregate events:

- widget added / removed by type and size;
- widget configuration saved;
- widget opened app;
- widget completion action succeeded;
- fallback state shown by category;
- widget refresh latency bucket.

Use analytics only to improve reliability and usability. Do not use widget activity to target ads, promotions, or manipulative engagement prompts.

---

## 15. Test Plan and Acceptance Criteria

### 15.1 Automated test coverage

Implement tests for:

- snapshot model generation across empty, normal, overdue, recurring, filtered, and large data sets;
- validation and integrity checks;
- atomic write behavior and retention of last known good snapshot;
- schema migration and configuration migration;
- task completion action idempotency;
- deleted-task navigation fallback;
- date/time-zone and midnight recalculation;
- sanitization of malformed and long task text;
- all approved empty/unavailable/recovery state render paths;
- logging events and prohibition of private task content in production logs.

### 15.2 Manual QA matrix

Test each widget type and supported size under all relevant conditions:

1. Fresh install before any task is created.
2. Empty task list and empty filtered list.
3. One task, many tasks, long task names, emoji, RTL text, and large font size.
4. Light/dark mode and all five Orbit accent colors.
5. App cold start, warm start, process kill, device restart, and app update.
6. Offline mode, battery saver, restricted background activity, and widget host refresh delay.
7. Time zone change, date change around midnight, and DST transition.
8. Deleted/archived tasks, invalid saved filter, and changed project names.
9. Rapid completion taps and repeated intent delivery.
10. Local storage failure simulation and invalid/missing snapshot simulation.
11. TalkBack/VoiceOver navigation and accessibility labels.
12. Launcher resizing and unusual home-screen grid sizes.

### 15.3 Release acceptance checklist

The feature is ready only when all conditions below are true:

- [ ] Every widget type renders correctly in its supported sizes.
- [ ] Every widget has intentional loading, content, empty, and recovery states.
- [ ] No technical error text, raw exception, blank failure surface, or endless loader can be produced in test scenarios.
- [ ] Last known good snapshot remains visible after simulated update/storage/render failures.
- [ ] Widget actions are idempotent and do not cause duplicate or incorrect task state changes.
- [ ] Logging captures required events without task content or personally identifying data.
- [ ] All deep links and back navigation paths behave correctly.
- [ ] Accessibility, large font, contrast, localization, and RTL tests pass.
- [ ] Performance budgets pass on the agreed device test matrix.
- [ ] Internal QA signs off on failure simulations and upgrade testing.

---

## 16. Delivery Phases

### Phase 1 — Foundation

- Shared snapshot schema and atomic storage.
- Last known good render policy.
- Structured logging framework.
- Today widget: small and medium layouts.
- Automated snapshot and fallback tests.

### Phase 2 — Core experience

- Today large layout, Inbox, Quick Add, and Focus widgets.
- Full configuration experience.
- Action queue, idempotency, and deep-link navigation.
- Android device/launcher test coverage.

### Phase 3 — Reliability hardening

- Failure simulation tools and debug screen.
- Upgrade/migration testing.
- Performance optimization for large task sets.
- Accessibility and localization validation.
- Production-safe diagnostic export.

### Phase 4 — iOS parity and refinement

- WidgetKit implementation aligned with this PRD.
- Platform-specific interaction adaptations while retaining product consistency.
- Monitor aggregate reliability signals and address recurring fallback reasons.

---

## 17. Final Product Standard

An Orbit Todo widget should feel like a dependable piece of the user’s home screen—not a fragile extension of the app. It must be fast, calm, readable, and ready when the user glances at it. When something unexpected happens, the widget preserves the last useful state, offers a simple recovery route, and records enough safe diagnostic information for the team to fix the root cause.

**The standard is simple: no broken widgets, no technical messages, no silent data mistakes—just a graceful, useful next action.**
