# Product Requirements Document
# Orbit Todo — Product Expansion: Customization, Planning, Reliability & Quality

**Document type:** Enhancement PRD  
**Product:** Orbit Todo (Flutter; Android and iOS)  
**Status:** Ready for product design, engineering, and QA  
**Scope:** Advanced customization, calendar and reminders, home-screen widgets, local-first performance and storage, onboarding, premium model, and quality assurance.

---

## 1. Executive Summary

Orbit Todo is a local-first task manager built on one promise: **simple by default, deep by choice**. This PRD defines the next product layer—features that let casual users stay focused while giving advanced users a highly adaptable personal system.

The product must remain fast, dependable offline, visually calm, and intentional. Advanced capability may never make the default interface feel complicated. Every feature must have a useful default, clear permissions, reversible settings, and graceful degradation when a device capability is unavailable.

This document complements the existing UX/UI and navigation PRD. Its component, typography, spacing, accessibility, theme, and back-navigation requirements remain mandatory.

---

## 2. Goals

1. Enable meaningful personalization without requiring setup before a user can add a task.
2. Make dates, reminders, and recurring work trustworthy across device restarts, time-zone changes, and offline use.
3. Offer useful home-screen widgets that support glance, completion, and rapid capture.
4. Preserve near-instant interaction on modest devices and large task libraries.
5. Create an onboarding path that reaches the first completed task quickly.
6. Introduce premium value without interrupting core productivity or creating dark patterns.
7. Establish measurable QA, accessibility, privacy, and release standards.

### Success measures

- A new user can create and complete a first task in under 60 seconds.
- Common screens become interactive within 1.5 seconds on the supported baseline device.
- Create, complete, edit, and reorder actions feel immediate; visual feedback begins within 100 ms.
- Scheduled reminders fire accurately under supported OS conditions and never fire after a task is completed or deleted.
- 99% of automated core-flow test runs pass before a release candidate is approved.
- At least 90% of users can find and use basic tasks without opening advanced settings.

---

## 3. Product Principles and Guardrails

- **Local first:** task creation, editing, search, views, and reminders must work without a network or account.
- **Progressive disclosure:** do not show custom fields, advanced filters, automation, or premium upsells until relevant.
- **Explain control:** when data is parsed, filtered, scheduled, or changed automatically, show the user what will happen and how to undo it.
- **No fake urgency:** no countdowns, deceptive trial copy, forced reviews, or ads.
- **Useful defaults, total reversibility:** users can restore defaults and opt out of any optional feature.
- **Native where it matters:** respect Android/iOS permission models, notification behavior, widgets, gestures, dynamic type, and accessibility settings.

---

## 4. Advanced Customization

### 4.1 User outcomes

Users can make Orbit Todo match their method—without needing to learn a productivity system. A user may keep the default Today/Inbox experience, while a power user can build tailored views, metadata, shortcuts, and workflows.

### 4.2 Customizable settings

Provide a dedicated **Customize** area, grouped into clear sections:

| Area | Requirements |
|---|---|
| Appearance | system/light/dark mode; five approved accent themes; five approved font styles; compact/standard density; reduce-motion preference follows device setting by default |
| Home | choose default root destination; configure Today sections and order; show/hide optional counts and completed tasks |
| Navigation | reorder or hide eligible root destinations; at least Today and Inbox remain available; restore default navigation |
| Task fields | enable optional fields (priority, duration, start date, tags, links); create/manage custom fields for advanced users |
| Task behavior | default project, default reminder, completion behavior, archive rules, quick-add parsing preference |
| Views | saved Smart Lists, list sorting, grouping, display density, and visible task metadata |

### 4.3 Smart Lists and filters

A Smart List is a named, saved query. It can filter by project, tag, completion, due/start date, priority, reminder state, recurrence, duration, and supported custom-field values. It can define sort order and grouping.

Requirements:

- Ship editable defaults: Overdue, High Priority, No Due Date, and Recently Completed.
- Let users create, duplicate, rename, reorder, pin, hide, and delete personal Smart Lists.
- Provide a human-readable query summary, e.g., “Work tasks due this week, high priority first.”
- Filter builder must provide an explicit **Apply**, **Clear**, and **Save as Smart List** action. Never silently preserve a confusing filter state.
- Store results locally and update them immediately after task mutations.
- Smart Lists are read-only views; opening a task always shows its source project/list.

### 4.4 Custom fields

Support text, number, checkbox, single-select, date, and URL custom field types. Custom fields are attached to a project by default; optionally allow a global field.

- Field creation and schema changes are advanced actions and require an explanatory empty state.
- A field has a name, optional icon, type, default value, visibility in task details, and optional visibility in task rows.
- Changing a field type is allowed only when lossless; otherwise require an explicit migration/confirmation.
- Deleting a field warns that stored values will be removed and offers export/backup guidance where available.
- Limit v1 to 20 fields per project and 10 fields visible in a task editor to protect usability and performance.

### 4.5 Templates, shortcuts, and bulk actions

- Users can save a task or project setup as a template, including subtasks, reminders, recurrence, and supported metadata.
- Templates can be created from the task menu and used from quick add.
- Support multi-select bulk complete, move, tag, archive, delete, and reschedule actions. Destructive actions require confirmation or an immediate Undo path.
- Provide keyboard shortcuts on hardware keyboards for add, search, focus navigation, complete, and escape/back. Show shortcuts in contextual menus.

### 4.6 Acceptance criteria

- A default user sees no more than the essential task fields until “More options” is selected.
- A Smart List created offline survives app restart and updates after a matching task changes.
- Font, density, theme, and home preferences apply immediately and persist.
- Restore Defaults affects only the selected customization section and explains what will change.

---

## 5. Calendar, Scheduling, and Reminders

### 5.1 Calendar experience

Upcoming provides an agenda-first calendar experience. Users must be able to see what is due, scheduled, and overdue without turning the app into an overloaded calendar clone.

Requirements:

- Offer agenda timeline as the default; provide week and month views when screen size permits.
- Clearly distinguish due dates, planned/start dates, and all-day items using labels and accessible non-color cues.
- Tapping a day filters the agenda; tapping a task opens task details.
- Drag-and-drop scheduling is supported where input form factor makes it reliable. It must show a clear drop target and be undoable.
- Rescheduling an item preserves its time and reminder logic unless the user explicitly changes them.
- Unschedule is always available; never require users to choose a replacement date.

### 5.2 Device calendar integration

Calendar integration is opt-in and configured from Settings or a clear prompt at first use—not during initial onboarding.

**Version 1:** export selected task due dates to a user-chosen device calendar, and import calendar events as non-editable “busy context” in the Upcoming view.  
**Out of scope for v1:** unrestricted two-way task/event synchronization.

Requirements:

- Request calendar access only after the user initiates connect/import/export.
- Explain exactly what is read or written before the OS permission dialog.
- Let users select calendars and choose whether exported entries include task notes.
- Mark exported events as Orbit Todo managed and prevent duplicate exports.
- If access is denied or revoked, keep tasks intact and show a non-blocking reconnect option.

### 5.3 Reminders and alarms

A reminder is a notification attached to a task; an alarm is a high-attention, time-specific reminder where platform policy permits. Both must be local and functional offline.

- Allow one or more reminders per task: at due time, before due time, or custom date/time.
- For date-only tasks, offer a configurable default reminder time; do not assume midnight.
- Support reminder presets (at time, 10 minutes before, 1 hour before, 1 day before) plus custom scheduling.
- Recurring tasks create the next applicable occurrence only after the current occurrence is completed, unless a chosen recurrence policy says otherwise.
- Completing, deleting, permanently deleting, or archiving a task cancels its future notifications.
- Snooze offers sensible values (10 minutes, 1 hour, tomorrow, custom) and records the changed schedule.
- Notification actions: Complete, Snooze, and Open. Actions must be idempotent—repeated taps cannot corrupt task state.
- If exact alarms are unavailable because of OS policy, explain the limitation and use the best permitted notification mechanism. Never promise precision the OS cannot guarantee.

### 5.4 Time-zone and daylight-saving rules

- Store date-only values as date-only values; do not convert them to a UTC timestamp that shifts the visible day.
- Store timed reminders with timezone context and recalculate future schedules after a timezone change, device reboot, app update, and daylight-saving transition.
- For recurring tasks, use the task’s chosen local time unless the user changes it.
- Add automated tests for DST forward/back transitions and timezone travel.

### 5.5 Acceptance criteria

- A completed task cannot generate a later reminder.
- A date-only task remains on the same calendar date after a timezone change.
- A denied calendar/notification permission never blocks task management.
- Every notification action produces the same correct state whether performed from a notification or within the app.

---

## 6. Home-Screen Widgets

### 6.1 Widget suite

Provide widgets that are concise, readable, and genuinely actionable. Widgets inherit the selected app theme where the operating system allows it and always meet contrast requirements.

| Widget | Sizes | Content / actions |
|---|---|---|
| Today | Small, medium, large | today count; next 1–8 tasks depending on size; tap to open task/app |
| Quick Add | Small | one-tap new task; opens focused quick-add sheet |
| Inbox | Medium, large | recent inbox tasks and count; tap task to open it |
| Focus | Medium | one selected Smart List or project; configurable in app |

Requirements:

- Keep widget layouts compact; no decorative empty cards or redundant headers.
- Users configure a widget’s list/project in the app; show a helpful configuration state if no source exists.
- Widget task completion is allowed only where reliable platform support exists; otherwise tapping opens the task detail. Completion must have Undo in the app and refresh the widget promptly.
- Use explicit refresh after app task changes and appropriate platform timeline refresh rules. Do not drain battery with excessive updates.
- Widgets must never expose sensitive notes by default on a locked device when the OS supports privacy controls.

### 6.2 Acceptance criteria

- A configured widget displays correct data after app restart and device reboot.
- Task edits made in the app appear in widgets within the platform-appropriate refresh window.
- Tapping any widget element opens the intended task or destination without a broken back stack.

---

## 7. Local Storage, Performance, and Data Reliability

### 7.1 Architecture requirements

Use a robust local database appropriate for indexed task queries and atomic writes (for example, Drift/SQLite or Isar). Do not use simple key-value storage as the primary task database.

Core entities: tasks, projects, tags, task-tag joins, subtasks, reminders, recurrence rules, custom-field definitions, custom-field values, Smart Lists, templates, app preferences, and tombstones/archives as needed.

- Data access is repository-based; user interface code must not issue raw database queries.
- Use migrations with version numbers, migration tests, and safe rollback/recovery behavior.
- All multi-entity changes (e.g., complete recurring task + schedule next occurrence + cancel reminder) run atomically.
- Index fields used for Today, Upcoming, search, project, status, priority, sorting, and reminder queries.

### 7.2 Performance targets

| Interaction | Target |
|---|---|
| Cold launch to usable primary view | ≤ 1.5 seconds baseline device; ≤ 2.5 seconds low-end supported device |
| Add/edit/complete visual acknowledgement | ≤ 100 ms |
| Search first local results | ≤ 200 ms for 10,000 tasks |
| Scroll task list | stable 60 fps on supported devices; no avoidable jank |
| Switch root destination | ≤ 150 ms after initial data load |

Implementation expectations:

- Paginate/virtualize long lists; do not render the entire task history.
- Debounce search input and cancel stale searches.
- Avoid rebuilding whole screens for a single task mutation; use narrow reactive state updates.
- Parse natural language and run heavy queries off the UI thread where profiling indicates need.
- Profile release builds on real representative devices, not only emulator/debug builds.

### 7.3 Backup, export, and recovery

- Provide manual export to a documented, portable format (JSON/CSV as appropriate) including tasks, projects, tags, and user-created configuration.
- Provide an import preview showing counts, conflicts, and the user’s chosen merge/replace behavior.
- Create an automatic local safety backup before destructive import or schema migration when storage permits.
- Never upload user task data without a separate, informed future sync choice.
- If database opening/migration fails, preserve the original data, show a clear recovery screen, and offer export/support diagnostics without silently resetting data.

### 7.4 Privacy and security

- Collect no task content for analytics, advertising, or review prompts.
- Diagnostic telemetry, if added, must be opt-in, anonymized, and documented.
- Do not log task titles, notes, reminders, or custom-field values in production logs.
- Store attachments only when the user chooses them; clearly show local file access implications.

---

## 8. Onboarding and Re-engagement

### 8.1 First-run flow

Onboarding must be short, skippable, and task-oriented. The required path is:

1. Welcome: one sentence explaining the value; **Get Started** and **Explore First**.
2. Create first task: focused title input with one optional suggested example.
3. Complete or schedule it: small, contextual guidance only.
4. Arrive in Today with a brief success moment and clear add affordance.

Do not require account creation, notification permission, calendar access, theme choice, or a tutorial carousel before first task creation.

### 8.2 Contextual education

- Introduce reminders only when a user sets a due time or opens reminder controls.
- Introduce widgets from Settings or after users demonstrate repeated daily use; never interrupt task capture.
- Introduce Smart Lists after a user has enough tasks/projects for filters to be useful.
- Use one small coachmark at a time, never repeat dismissed education, and include “Don’t show again.”

### 8.3 Empty states

Every empty state must state what the view means, offer one relevant action, and avoid excessive illustration/blank space. Examples:

- Inbox: “Nothing waiting to be sorted.” / **Add a task**
- Today: “Your day is clear.” / **Plan something**
- Projects: “Group work when a simple list is not enough.” / **Create project**

### 8.4 In-app review

Request an app review only after demonstrated positive value: for example, after 7 days since install and 10 completed tasks, with no recent crash or negative feedback signal. Use the system review surface; never block usage, ask repeatedly, or solicit a rating before showing it.

---

## 9. Premium Model

### 9.1 Positioning

Core task management is permanently useful without payment. Premium funds advanced personalization and productivity—not basic dignity.

### 9.2 Suggested entitlement structure

**Free:** unlimited tasks, projects, tags, basic reminders, core calendar views, light/dark modes, all five accent colors, local export, and one basic widget configuration.  
**Orbit Pro:** unlimited Smart Lists, advanced custom fields, templates, multiple reminders, advanced recurrence, all widget types/configurations, richer calendar integration, advanced bulk actions, and future optional sync/storage offerings.

Final entitlement choices must be validated against market research and app-store rules before implementation. Do not add feature limits that make the free app unusable.

### 9.3 Paywall requirements

- Show a paywall only after the user selects a premium-only action or voluntarily opens Upgrade.
- State the locked benefit, price, billing interval, trial terms, and restore-purchases option plainly.
- Provide **Not now** and return users exactly where they were.
- Verify entitlement locally with store-supported mechanisms and cache a valid entitlement for reasonable offline use.
- If purchase verification is temporarily unavailable, do not erase already-granted access; show a non-alarming retry state.
- Never gate data export, access to existing user data, or task completion behind payment.

---

## 10. QA, Accessibility, and Release Requirements

### 10.1 Test strategy

| Layer | Required coverage |
|---|---|
| Unit | recurrence, timezone/DST, query/filter logic, permissions state handling, notification schedule/cancel logic, migrations, entitlement rules |
| Widget | task row states, custom-field controls, text scaling, theme/font variants, validation, empty/loading/error states |
| Integration | create/edit/complete/delete/undo; back navigation; offline restart; notification actions; import/export; widget deep links; purchase restore |
| Manual device QA | Android and iOS physical devices, compact/large layouts, low-memory conditions, permission denial/revocation, device reboot, dark mode |

### 10.2 Mandatory test matrix

Test every release candidate with:

- light, dark, and system theme;
- all five accent colors and five font styles;
- normal, large, and maximum supported text scale;
- Android back button/gesture and iOS swipe/back conventions;
- offline mode from cold start;
- at least 0, 1, 100, 1,000, and 10,000 task datasets;
- notification/calendar permission: not requested, allowed, denied, and revoked;
- timezone change and DST boundary where applicable;
- widgets in each supported size;
- upgrade, restore purchase, and offline entitlement state if monetization ships.

### 10.3 Accessibility acceptance requirements

- All actionable controls have accessible labels and at least 44×44 logical-pixel targets.
- Screen-reader users hear task completion, reminder, priority, and selection state.
- No status relies only on color.
- All primary flows work with keyboard and visible focus when a keyboard is connected.
- Text must not clip, overlap, or become inaccessible at supported scaling.
- Reduced-motion settings eliminate nonessential motion without removing state feedback.

### 10.4 Release gates

A release candidate cannot ship if it has:

- a data-loss, duplicate-reminder, or missed-reminder defect reproducible in core flows;
- a crash/blocker in add, edit, complete, delete/undo, search, launch, or back navigation;
- an accessibility blocker in core task flows;
- unreviewed database migration behavior;
- unresolved high-severity privacy/security issue;
- performance below targets without a documented and approved exception.

---

## 11. Delivery Plan

### Phase 1 — Trust and foundation
Local database/migrations, performance instrumentation, export/backup, onboarding, core reminders, and automated core-flow tests.

### Phase 2 — Planning and personalization
Upcoming calendar improvements, Smart Lists, customization settings, templates, custom fields, and advanced filters.

### Phase 3 — Surface area and monetization
Widgets, opt-in calendar integration, premium entitlements/paywall, in-app review rules, and release hardening.

Each phase must include design QA against the UX/UI Consistency & Navigation Enhancement PRD before feature completion.

---

## 12. Final Definition of Done

This expansion is complete when an everyday user can capture, plan, and finish tasks with no setup and no confusion; an advanced user can intentionally shape views and task structure; reminders and local data remain reliable; widgets provide real value; and every state looks, feels, and performs like one polished human-made product.
