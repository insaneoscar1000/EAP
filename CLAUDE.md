# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `flutter pub get` — fetch dependencies after editing `pubspec.yaml`.
- `flutter run -d <device-id>` — run the app. Get device IDs with `flutter devices`. For iOS simulator, boot one with `xcrun simctl boot <udid>` first.
- `flutter analyze` — static analysis using `analysis_options.yaml`.
- `flutter test` — run all tests. Single test: `flutter test test/path/to/file_test.dart --plain-name "<test name>"`.
- `flutter build ios` / `flutter build apk` — release builds.

### iOS / CocoaPods

If `flutter run` fails on iOS with a Firebase pod version mismatch, run from `ios/`:

```
LANG=en_US.UTF-8 pod repo update
LANG=en_US.UTF-8 pod update Firebase/Messaging
```

The `LANG` prefix is required because system Ruby (2.6) hits a Unicode encoding error otherwise. Firebase plugin versions are pinned through `firebase_core`'s SDK resolution, so updating one Firebase pod typically updates the whole set.

## Architecture

Flutter app using **Stacked + GetIt + Provider** (MVVM). Firebase backend, RevenueCat for subscriptions.

### Layers

- `lib/main.dart` — initializes Firebase, calls `setupLocator()`, then initializes `SubscriptionService` (RevenueCat) before `runApp(App())`.
- `lib/src/locator.dart` — single GetIt registration point. **All services must be registered here** as lazy singletons. Resolve with `locator<T>()`.
- `lib/src/app.dart` — root `MaterialApp`. Routing goes through `AppRouter.generateRoute` and navigation uses `NavigationService.navigationKey` (so view models can navigate without a `BuildContext`). Wraps the tree in `DialogManager` for centralized dialogs and `OverlaySupport` for toasts.
- `lib/src/ui/router.dart` — central switch over `RoutePaths` constants. **Every new view registers here**; arguments are typed via classes in `lib/src/core/arguments/` or passed directly.

### Feature folder convention

Features are mirrored across three locations and grouped by domain (`auth`, `home`, `network`, `projects`, `check_regs`, `eia_basics`, `subscription`):

- `lib/src/core/services/` — Firebase/data/app services (split into `app/` and `data/` subfolders, plus top-level `payment_service.dart`, `subscription_service.dart`). Re-exported from `services.dart`.
- `lib/src/core/view_models/<feature>/` — `BaseViewModel` subclasses (Stacked). Re-exported from `view_models.dart`.
- `lib/src/ui/views/<feature>/` — widget tree per view. Re-exported from `views.dart`.

When adding a feature, follow this trio and add exports to the corresponding barrel file. View models pull dependencies via `locator<T>()`, never via constructor injection from the view.

### Navigation pattern

`NavigationService` wraps the root `navigatorKey`. View models call it directly to navigate; views never call `Navigator.of(context).push` for app-level routes — they push named routes defined in `RoutePaths`.

### Subscriptions

RevenueCat (`purchases_flutter`) is initialized in `main.dart` *before* `runApp`. `SubscriptionService` is the single entry point; failures during init are swallowed with `debugPrint` so the app still launches offline.

## Lint rules of note

`analysis_options.yaml` enforces (beyond `flutter_lints`): `always_declare_return_types`, `prefer_single_quotes`, `always_specify_types`, `avoid_relative_lib_imports`. `prefer_const_*` rules are explicitly disabled — don't add `const` mechanically. `avoid_print` is off, so `print`/`debugPrint` are acceptable.

Imports inside `lib/` must use `package:the_eap_app/...` (not relative).
