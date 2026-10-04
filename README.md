# Taskly

A Flutter task-tracking app with a custom "liquid glass" visual style.

> **Status:** Early development. Core screens, local storage, and the
> add-task flow are in place. Task filtering and the task detail screen
> are still open.

## Tech stack

- **Flutter** (Impeller explicitly enabled on Android via
  `android/app/src/main/AndroidManifest.xml` →
  `io.flutter.embedding.android.EnableImpeller`)
- **Local database:** [`hive_ce`](https://pub.dev/packages/hive_ce) /
  `hive_ce_flutter` / `hive_ce_generator` + `build_runner` — chosen over
  the original Hive/Isar packages since both are no longer maintained by
  their original authors; `hive_ce` is the actively maintained community
  fork.
- **Glass UI effect:**
  [`liquid_glass_renderer`](https://pub.dev/packages/liquid_glass_renderer)
  — a real Impeller shader package that produces backdrop refraction, used
  for the bottom nav bar and a reusable `GlassContainer` widget.

## Platform support

- Developed and tested on a real **Android** device.
- **iOS is unverified.** Development is on Windows with no Mac/Xcode
  available, so there's no way to build or test for iOS locally. No
  native iOS glass tier (e.g. `UIGlassEffect` on iOS 26+) has been
  pursued for the same reason — the single `liquid_glass_renderer`-based
  implementation is meant to run on both platforms, but only the Android
  side has actually been confirmed.

## Project structure

```
lib/
  main.dart                        # Hive init, box setup, task seeding, MaterialApp
  models/
    task.dart                      # Task Hive model (typeId: 0)
  data/
    task_box.dart                  # Shortcut: Box<Task> get taskBox
  screens/
    splash_screen.dart             # Animated progress bar + shader pre-warm
    welcome_screen.dart            # "Get Started" entry point
    main_screen.dart               # IndexedStack of tabs + CustomGlassNavBar
    home_screen.dart               # Greeting, stat cards, filter tabs, task list, add-task sheet
    task_screen.dart               # Task detail page (not built out yet)
  widgets/
    task_list.dart                 # Renders tasks as ListTiles
    add_task_form.dart             # Form used inside the add-task bottom sheet
    glass_container.dart           # Reusable glass/shadow container
    custom_glass_nav_bar.dart      # Hand-built bottom nav with drag-to-switch
    checkbox.dart                  # PremiumCheckbox (animated, gradient fill)
  utils/
    string_extensions.dart         # String.capitalize()
    page_transitions.dart          # slideRoute() — shared screen transition
```

## Features implemented so far

- **Hive-backed persistence** — tasks are stored locally and the UI
  updates live via `ValueListenableBuilder` on the task box.
- **Splash → Welcome → Main flow**, with a shader pre-warm step on the
  splash screen so `LiquidGlass` shaders compile before the user reaches
  the main UI (prevents first-frame jank).
- **Home screen**: greeting, remaining/completed stat cards, category
  filter tabs (All / Personal / Work), and the task list.
- **Add Task flow**: a floating action button opens a persistent (non-
  modal) bottom sheet containing a form — title field, category chips,
  and priority chips — that saves directly to the Hive box.
- **Custom glass bottom nav bar**: tap to switch tabs, hold-and-drag on
  the active tab to slide the indicator, bounce/expand animations, with
  refraction effects that activate only while dragging (for performance).
- **Shared slide transition** (`slideRoute`) used for screen navigation.
- **Overscroll stretch effect disabled app-wide** — the default Android
  stretch indicator visually conflicted with the glass shaders (causing
  visible glitching on `GlassContainer`s and images when over-scrolling),
  so it's turned off via `scrollBehavior` on `MaterialApp`.

## Known open items

- Task list filtering by category tab is not wired up yet — tapping a
  tab updates state but the list doesn't filter by it.
- `TaskScreen` (task detail page) is referenced but not built.
- Light-mode `GlassContainer` appearance hasn't been visually confirmed
  on a real device (only dark mode has been tested so far).

## Considered, not yet done

- Converting `Task.dueDate` from `String` (empty string = no due date)
  to nullable `DateTime?`.
- Converting the `_tabs` list (`Map<String, Object>`) in `HomeScreen`
  into a proper `FilterTab` class for compile-time safety.
- Swapping in `FakeGlass` (a cheaper, non-refracting widget from
  `liquid_glass_renderer`) as a fallback if the nav bar's real-time
  refraction proves too GPU-expensive on lower-end devices.

## Development notes

- `@HiveField` numbers on `Task` must never be reused or reassigned once
  data exists — only ever add new fields with fresh numbers.
- `GlassContainer` does not take a `width` parameter — wrap it in a
  `SizedBox` from the outside for fixed widths.
- `showBottomSheet` attaches to the nearest `Scaffold` above the given
  `context`, so `HomeScreen`'s `Scaffold` uses a `GlobalKey` to open its
  sheet reliably.
