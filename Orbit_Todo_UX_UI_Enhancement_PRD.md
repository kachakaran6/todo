# Product Requirements Document
# Orbit Todo — UX/UI Consistency & Navigation Enhancement

**Document type:** Enhancement PRD  
**Product:** Orbit Todo (Flutter, Android and iOS)  
**Status:** Ready for design and engineering  
**Priority:** High — product-quality foundation  
**Scope:** User experience, visual design consistency, typography preferences, responsive spacing, and back-navigation behavior  

---

## 1. Executive Summary

Orbit Todo must feel like a focused, human-made productivity product rather than a collection of screens. This enhancement establishes a single, consistent interaction and visual language across the app.

The work addresses four visible quality areas:

1. **Consistent UI:** common controls, predictable patterns, disciplined colors, typography, iconography, motion, and states.
2. **Typography choice:** five curated font-style options that users can select without damaging layout, performance, or readability.
3. **Correct back navigation:** a clear platform-native back behavior that returns users from detail screens to the first/home screen before allowing the application to close.
4. **Spacing discipline:** remove unnecessary gaps, oversized containers, duplicate padding, and empty visual noise. Every pixel of space must support hierarchy, touch comfort, readability, or intentional calm.

The result should be clean and fast: information-rich without feeling crowded, friendly without being childish, and powerful without appearing complex.

---

## 2. Problem Statement

To-do applications often become visually inconsistent as features grow. Common symptoms include:

- Different padding, button sizes, corner radii, and title styles from screen to screen.
- Too much blank space in lists, cards, sheets, and form sections, causing users to scroll more than necessary.
- Controls that look similar but behave differently.
- Multiple layers of navigation that create confusing back-button results.
- Fonts that feel generic or are applied inconsistently across titles, task rows, and settings.
- Empty states that waste the screen instead of helping the user take a next action.

Orbit Todo needs an explicit design system and navigation contract before advanced functionality expands further.

---

## 3. Goals

### Primary goals

- Make every screen feel like it belongs to one premium product.
- Increase information clarity and reduce unnecessary scrolling.
- Let users personalize the app’s typographic personality through five accessible options.
- Ensure hardware/software back actions and edge-swipe gestures behave predictably on Android and iOS.
- Preserve a simple default experience for everyday users.
- Maintain smooth performance across phones, tablets, light mode, dark mode, and all five accent colors.

### Success indicators

- No visible mismatch in component dimensions, typography, colors, or interaction patterns between core screens.
- Users can return from any non-home screen to the default home screen using the standard back action.
- From the home/root screen, the next Android back action exits the app naturally; iOS follows native app/gesture conventions and does not force-close.
- All layouts remain readable at supported text scales and with every supported font option.
- Core task lists show useful information without excessive vertical gaps or heavy card clutter.
- The UI passes design QA at common phone sizes, tablet sizes, light/dark modes, and dynamic text scaling.

---

## 4. Non-Goals

This PRD does **not** introduce cloud sync, account management, a complete brand redesign, new task-management functionality, or new monetization features.

This work does not mean making the UI visually dense at the expense of accessibility. “Remove unwanted spacing” means eliminating arbitrary or duplicate whitespace—not reducing touch targets, readability, focus indication, or visual grouping.

---

## 5. Design Principles

### 5.1 Calm density

Show enough information to be useful while keeping the page breathable. Dense does not mean cramped; minimal does not mean empty.

### 5.2 One pattern, one meaning

The same control must look and behave the same everywhere. A chip, icon button, checkbox, list row, sheet, and destructive action should never change meaning by screen.

### 5.3 Progressive disclosure

The task title and completion action are primary. Secondary attributes are visible only when useful. Editing, advanced filters, and customization can expand when requested.

### 5.4 Native expectations, polished execution

Use platform-appropriate gestures, back behavior, haptics, and modal patterns while preserving a single Orbit Todo visual identity.

### 5.5 Accessibility is structural

Minimum touch sizes, color contrast, text scaling, keyboard focus, semantic labels, and reduced-motion support are requirements, not later polish.

---

## 6. Information Architecture and Home Definition

### 6.1 Home/root screen

The default root destination is **Today**. It is the first home screen and represents the user’s daily action surface.

The bottom navigation contains the main root destinations, for example:

1. Today
2. Inbox
3. Upcoming
4. Projects
5. More / Customize

A user may select a different default landing page in Settings. That selected page becomes the app’s **home/root screen** for back-navigation behavior. The UI must make that preference clear.

### 6.2 Root destinations versus pushed screens

Root destinations are top-level tabs/pages. Screens such as task details, task editor, project details, filters, search, calendar detail, and settings subsections are pushed or presented above a root destination.

This distinction must be reflected in routing and back behavior. Do not treat every view as a separate independent home page.

---

## 7. Back Navigation Requirements

### 7.1 Navigation contract

The back action includes Android system back, Android predictive back gesture, Android three-button back, iOS leading-edge swipe gesture, app-bar back button, keyboard Escape where applicable, and desktop browser/back navigation when supported.

Back must dismiss the nearest active UI layer first, in this exact priority order:

1. Close contextual menus, tooltips, date pickers, and popovers.
2. Close dialogs and bottom sheets.
3. Exit selection / multi-select mode.
4. Clear focused search mode or filter-edit mode if it was opened within the current screen.
5. Close the task editor or task detail screen, handling unsaved changes appropriately.
6. Return from a child page (project detail, settings detail, calendar day, etc.) to its parent/root destination.
7. Return from any non-default root destination to the user’s configured home/root screen.
8. At the configured home/root screen, allow the platform’s normal exit/background behavior.

### 7.2 Android behavior

- If the user is on Inbox, Upcoming, Projects, or More and presses system Back, navigate to the configured home/root screen (default: Today).
- If the user is on a detail screen, back returns to the immediately logical parent first; it must not jump unexpectedly to Today while a parent screen exists.
- On Today/home with no transient UI open, Android system Back should exit/background the application according to OS behavior. Do not show a mandatory “Press back again to exit” toast unless it is an explicit user preference; it is unnecessary and feels dated.
- Implement Android predictive-back transitions correctly so the user sees the destination they will return to during the gesture.

### 7.3 iOS behavior

- Preserve standard iOS interactive swipe-back behavior on pushed routes.
- The app must not programmatically force-close when the user is on the home screen; iOS manages app lifecycle.
- In an app-bar context where a back control is shown, it must match the same hierarchy as swipe-back.

### 7.4 Unsaved changes

When leaving a task editor with meaningful unsaved changes, show a concise confirmation sheet:

- **Keep editing** (default, non-destructive)
- **Discard changes** (destructive)
- **Save and leave** when a valid task can be saved

Do not prompt if nothing changed. For a quick-add sheet, preserve draft input during temporary interruptions where feasible.

### 7.5 Acceptance criteria: back navigation

- Back from an open filter sheet closes the sheet, not the page.
- Back from a task editor returns to the correct source page.
- Back from a Project detail returns to Projects; a subsequent back returns to Today/home if Projects is not the configured home.
- Back from Inbox returns to Today/home when Inbox is not the configured home.
- Back from Today/home yields native platform exit/background behavior on Android; it never force-closes iOS.
- The route visible during Android predictive back matches the actual final destination.
- No back action results in a blank screen, duplicate route, lost state, or navigation loop.

---

## 8. Visual Design System

### 8.1 Design tokens

Create a centralized token system. No production screen may hard-code visual values that already have a token.

Define tokens for:

- Color: semantic roles, all five accents, light/dark surfaces, outlines, text hierarchy, success, warning, destructive, priority colors, selection, and disabled states.
- Typography: font family, scale, weight, line height, letter spacing, and numeral behavior.
- Spacing: a documented 4-point base scale.
- Shape: corner radius and component shape rules.
- Elevation: surface hierarchy and shadows.
- Motion: durations, curves, and reduced-motion alternatives.
- Icon sizes and stroke/visual-weight rules.

Use semantic names such as `surfacePrimary`, `textSecondary`, `actionDestructive`, and `spacing12`, rather than component-specific or raw color names.

### 8.2 Spacing scale

Use a 4dp base unit and restrict standard layout spacing to the following scale unless an accessibility or platform requirement needs otherwise:

| Token | Size | Typical use |
|---|---:|---|
| `space4` | 4dp | Icon-to-label, micro separation |
| `space8` | 8dp | Compact internal gaps |
| `space12` | 12dp | Standard row/component gap |
| `space16` | 16dp | Standard screen horizontal padding |
| `space20` | 20dp | Major section gap |
| `space24` | 24dp | Page section separation |
| `space32` | 32dp | Intentional large break / empty-state spacing |
| `space40` | 40dp | Rare, hero-only spacing |

Rules:

- Standard phone screen horizontal padding: **16dp**.
- Compact dense list horizontal padding: **12–16dp**, never arbitrary values.
- Standard section-to-section vertical gap: **20–24dp**.
- Do not stack page padding + card padding + list padding unless each layer has a clear visual responsibility.
- Avoid default `SizedBox(height: 24)` between every widget. Space must express relationship.
- Use a smaller gap inside a group and a larger gap between groups.
- Maintain touch targets of at least 44dp on iOS and 48dp on Android even when the visual icon or checkbox is smaller.

### 8.3 Density modes

Provide three user-selectable density modes in Settings:

- **Comfortable (default):** generous but efficient. Best for most users.
- **Compact:** more task rows visible; reduced vertical padding while preserving touch targets.
- **Spacious:** extra separation for users who prefer readability or use larger text.

Density changes list-row padding, section spacing, and metadata placement. It must not change font family, break touch targets, alter navigation behavior, or create inconsistent shapes.

### 8.4 Surfaces, cards, and dividers

- Default task lists should look like a refined list, not a screen full of floating cards.
- Use cards only for genuinely grouped or actionable content: a focus panel, onboarding prompt, task editor section, or elevated contextual element.
- Prefer subtle dividers, background grouping, and spacing over heavy shadows.
- In dark mode, use tonal surface contrast rather than bright gray borders everywhere.
- Use one consistent radius family: small for fields/chips, medium for sheets/cards, larger only for special hero/empty-state areas.

---

## 9. Typography and Five Font Style Options

### 9.1 Requirements

Users can choose one of five curated typography styles in **Settings → Appearance → Font style**. The default is **Modern**. The option affects the whole app, including navigation, task rows, editors, dialogs, widgets where supported, and user-visible settings previews.

Fonts must be legally suitable for app distribution, packaged efficiently, and loaded without a visible layout jump. If a desired font is not available on a platform or widget surface, use the defined fallback stack and preserve visual hierarchy.

### 9.2 Font options

| Style | Primary font direction | Product personality | Best use |
|---|---|---|---|
| **Modern** (default) | Inter / platform-compatible modern sans | Clean, neutral, highly legible | Everyday task management |
| **Rounded** | Nunito Sans or a similar refined rounded sans | Friendly, optimistic, warm | Personal planning |
| **Editorial** | Source Serif 4 for headings + clean sans body | Thoughtful, premium, journal-like | Reflective planning and long notes |
| **Geometric** | Manrope or similar geometric sans | Crisp, contemporary, structured | Productivity-focused users |
| **Classic** | System UI / SF Pro on iOS, Roboto on Android | Native, familiar, ultra-efficient | Users preferring platform conventions |

The final font selection must be checked for licensing, glyph coverage, numerical readability, rendering quality, and Flutter platform performance before implementation.

### 9.3 Type scale

Establish one responsive type scale. Do not use arbitrary font sizes in screens.

| Role | Base size | Weight | Use |
|---|---:|---|---|
| Display | 28sp | 700 | Major page title when appropriate |
| Title | 22sp | 700 | Screen/app-bar title |
| Section title | 17sp | 650–700 | Group headings |
| Task title | 16sp | 500–600 | Primary task label |
| Body | 15sp | 400 | Notes and normal content |
| Metadata | 13sp | 500 | Date, project, labels, helper content |
| Caption | 12sp | 500 | Secondary compact details |

Rules:

- Use tabular figures for times, dates, counters, and progress values when supported by the font.
- Do not use all caps for long labels; use sentence case.
- Apply no more than three visual text levels within one task row.
- Let system text scaling work. Test at 80%, 100%, 130%, and 200% scale; wrap/reflow rather than truncate important content.
- A font-style change persists immediately and applies after restart.

### 9.4 Font selector experience

The selector displays a live preview sentence, a sample task row, a due-date chip, and a small section heading. It must not be a list of font names alone. Applying a selection is immediate, reversible, and does not require an app restart.

---

## 10. Component Consistency Requirements

### 10.1 Task row

The task row is the product’s most important component. It must have one canonical design and variants rather than separate ad hoc implementations.

Required elements, ordered by priority:

1. Completion control with clear unchecked, checked, disabled, and overdue context states.
2. Task title (up to two lines before truncation in standard lists).
3. Compact metadata only when present: due date/time, project, priority, recurrence, subtask progress, tags.
4. Optional trailing affordance for more actions or drag/reorder, depending on context.

Rules:

- Keep metadata visually quieter than the title.
- Avoid showing every possible attribute at once. Prioritize deadline, urgency, and project context.
- Completion must not cause list jumping or an accidental tap on the next row.
- Use stable row height behavior and smooth movement on complete/restore.
- Support comfortable, compact, and spacious variants using the same component contract.

### 10.2 Buttons

Define exactly these primary types:

- **Primary filled:** one dominant action per screen/section.
- **Secondary tonal/outlined:** supporting action.
- **Text button:** low-emphasis action.
- **Icon button:** recognizable compact action with accessible label and 44/48dp hit target.
- **Destructive action:** clearly separated and never visually identical to save/confirm.

Do not mix multiple primary filled buttons in a small area. Use verbs: “Add task,” “Save changes,” “Discard,” not vague labels such as “Done” where the meaning is unclear.

### 10.3 Inputs, chips, and selectors

- Input labels remain visible or clearly discoverable; placeholder text is not the only label.
- Use the same field height, focus state, error state, and clear-button pattern across the app.
- Chips represent an active filter, tag, date, or selectable property—not a random decorative label.
- Filter chips must show active state accessibly and provide a clear removal mechanism.
- Multi-select and single-select controls must not look identical when their behavior differs.

### 10.4 Sheets, dialogs, and menus

- Use a bottom sheet for focused mobile actions that benefit from easy thumb reach (quick add, task actions, filter controls).
- Use a dialog for confirmation or a decision that should not be dismissed accidentally.
- Use menus for short, non-destructive contextual actions.
- Follow one title/action alignment pattern across all sheets and dialogs.
- Bottom sheets must accommodate keyboard appearance, dynamic text, safe areas, and screen readers.

### 10.5 Icons and imagery

- Adopt a single icon family and visual weight.
- Do not use emoji as primary product icons.
- Icons must have a text/semantic label when meaning is not universally obvious.
- Empty-state illustrations, if used, must be sparse, consistent, lightweight, and not consume more than necessary screen space.

---

## 11. Screen-Level UX Requirements

### 11.1 Today

- A concise page header with date context and only the most useful action(s).
- Group overdue, scheduled, and later tasks clearly without exaggerated gaps.
- Empty Today state should explain that the day is clear and offer a single “Add task” action; it must not fill the screen with decorative content.
- Do not place a large welcome card above the actual task list every day.

### 11.2 Inbox

- Prioritize rapid capture and processing.
- Keep filters/counters secondary; the task list and add action own the page.
- No unnecessary introductory copy once the user has tasks.

### 11.3 Upcoming and Calendar

- Use strong date hierarchy and compact task rows.
- Avoid repeating the same date label at multiple visual levels.
- The selected day, current day, and days with tasks must be distinguishable in more than color alone.

### 11.4 Projects

- Projects should scan quickly by name, color/icon, and meaningful task count.
- Use lists or a deliberate grid based on screen size—not a random mix.
- Project detail applies the same canonical task-row and filter patterns as Today.

### 11.5 Task editor

- Opens in compact mode: title, notes, date, and save/add are immediately available.
- Advanced options stay collapsed behind a clear “More details” control.
- Field order follows user thinking: what → when → context → reminders/repeat → advanced fields.
- Remove redundant containers and labels. Use semantic section separation, not excessive cards.
- Keep the save action obvious and reachable above keyboard/safe-area constraints.

### 11.6 Settings and Customize

- Group settings by purpose: Appearance, Task behavior, Navigation, Notifications, Data, About.
- Do not create deep nested settings pages when a simple inline selector works.
- Each preference has a concise description only when it prevents confusion; avoid explanatory paragraphs for obvious settings.

---

## 12. Responsive and Accessibility Requirements

### Responsive behavior

- Phone: 16dp horizontal content padding; bottom navigation; bottom sheets for contextual task controls.
- Tablet: navigation rail/side bar where appropriate; use extra width for task detail or calendar content, not larger empty margins.
- Desktop/web-capable: a max reading width for prose/settings, but lists and work surfaces should use available space intelligently.
- Handle portrait, landscape, small screens, split-screen, keyboard, and safe-area insets without clipped actions or accidental white space.

### Accessibility requirements

- Meet WCAG AA contrast for text and essential controls in every theme/accent pair.
- Support system dynamic text with no hidden content or inaccessible dialogs.
- Provide semantic labels for completion, priority, due date, and interactive icons.
- Ensure a keyboard user can reach, operate, and dismiss every control.
- Respect reduced motion and high contrast settings.
- Never convey completed, overdue, selected, or error states by color alone.

---

## 13. Performance Requirements

Visual refinement must not make Orbit Todo feel slower.

- Theme, accent, font, and density changes apply in under 200ms perceived time on a representative mid-range device.
- Avoid expensive whole-app rebuilds for local appearance changes; update only dependent UI where possible.
- Cache/bundle fonts appropriately; do not download a font at runtime to render the primary UI.
- No blocking animation or layout shift during font switching.
- Lists continue to use efficient lazy rendering under all density/font options.
- Avoid blur-heavy surfaces, large shadows, continuously animated decoration, or nested scroll structures without demonstrated need.

---

## 14. Analytics and Feedback (Optional, Privacy-Respecting)

If product analytics are later enabled, collect only opt-in, aggregated interaction signals useful for UX evaluation, such as font-style selection, density selection, back-navigation cancellations, and usage of visual customization. Do not collect task titles, notes, project names, or other personal content.

Until a consented analytics system exists, validate this PRD with moderated usability sessions and internal QA.

---

## 15. Implementation Guidance

### Flutter implementation expectations

- Create centralized theme extensions/tokens for spacing, typography, shape, and semantic colors.
- Support five `TextTheme` configurations or font-family mappings, preserving role-based sizes and weights.
- Persist appearance and navigation preferences locally.
- Use a single route/navigation policy for app-bar back, system back, gesture back, and keyboard Escape behavior.
- Use a navigation shell for root destinations so changing tabs preserves expected list scroll/state where appropriate.
- Explicitly handle unsaved-editor state instead of relying on accidental route disposal.
- Add golden tests for each core screen across light/dark, five accents, and the typography/density extremes.

### Design QA checklist

Review every core screen for:

- Correct 4dp-scale spacing and absence of duplicate padding.
- Consistent title hierarchy, font, icon style, radius, elevation, and state color.
- Correct empty/loading/error/disabled/selected/focused states.
- Long text, no-task state, many-task state, dynamic text, and RTL readiness where possible.
- Correct back behavior from every nested page, modal, and root tab.

---

## 16. Rollout Plan

### Phase A — Foundation

1. Audit all existing screens/components for duplicate styles and spacing inconsistencies.
2. Define and implement tokens, canonical components, typography scale, density rules, and navigation policy.
3. Refactor the Today, Inbox, task row, task editor, app bar, sheets, and bottom navigation first.

### Phase B — Personalization

1. Add font-style selector and live preview.
2. Add density selector and persist settings.
3. Apply theme tokens to all remaining screens and device widget surfaces where supported.

### Phase C — Hardening

1. Test back behavior on Android gesture navigation, Android buttons, iOS edge swipe, keyboard, and deep links.
2. Test all font options across supported text scales, screen sizes, light/dark mode, and all accents.
3. Complete accessibility review, golden tests, performance profiling, and visual QA sign-off.

---

## 17. Final Acceptance Criteria

This enhancement is complete only when all of the following are true:

- [ ] Today/home is clearly defined and configurable as the user’s preferred root destination.
- [ ] Back closes transient UI first, then navigates through parent screens, then returns non-home tabs to home, then allows normal Android exit behavior.
- [ ] iOS keeps native lifecycle and swipe-back expectations; the app never force-quits.
- [ ] Five font styles are available, previewable, persistent, accessible, and visually consistent throughout the app.
- [ ] Every screen uses the shared typography, spacing, shape, color, and component token system.
- [ ] Unnecessary whitespace, duplicate padding, oversized empty states, and card-overuse have been removed without harming accessibility.
- [ ] Comfortable, Compact, and Spacious densities work consistently.
- [ ] Light and dark mode, five accents, dynamic text, and responsive layouts pass visual QA.
- [ ] Core task lists remain smooth and usable with large local datasets.
- [ ] Automated tests cover navigation behavior, preference persistence, and primary visual variants.
- [ ] No placeholder UI, inconsistent icon sets, arbitrary spacing values, or unexplained navigation behavior remains in the release candidate.

---

## 18. Product Quality Bar

The final experience should make the user feel that every interface choice was made on purpose. It should be clear in one second, comfortable for an hour, and customizable for years. Remove anything that does not help the user decide, act, understand, or enjoy the flow.
