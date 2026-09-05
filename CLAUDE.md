# yurideks_app

Flutter application. Clean Architecture + feature-based structure + BLoC state management.

## Non-negotiable rules

1. **No comments.** Never write comments in Dart code — no `//`, no `///` doc comments, no `/* */`, no TODO/FIXME notes, no section banners. Code must explain itself through naming. Remove comments from any file you touch, including the Flutter template boilerplate.
2. **Clean Architecture.** Every feature is split into `data`, `domain`, `presentation`. Dependencies point inward only: `presentation → domain ← data`. `domain` imports nothing from `data` or `presentation` and nothing from Flutter.
3. **BLoC only.** State is managed with `flutter_bloc`. No `setState` in feature widgets, no `Provider`/`Riverpod`/`GetX`/`ChangeNotifier` for feature state.
4. **Feature-based.** New code goes under `lib/features/<feature>/`. Shared code goes under `lib/core/`. Never create a global `screens/`, `widgets/`, or `models/` folder at `lib/` root.

## Directory layout

```
lib/
  main.dart
  app/
    app.dart
    app_router.dart
    app_routes.dart
    bloc_observer.dart
  core/
    theme/            app_colors.dart, app_typography.dart, app_spacing.dart, app_theme.dart
    di/               injector.dart
    error/            failures.dart, exceptions.dart, failure_message.dart
    usecase/          usecase.dart
    utils/
    constants/
    widgets/          shared, feature-agnostic widgets only
  features/
    <feature>/
      data/
        datasources/  <feature>_remote_data_source.dart, <feature>_local_data_source.dart
        models/       <entity>_model.dart
        repositories/ <feature>_repository_impl.dart
      domain/
        entities/     <entity>.dart
        repositories/ <feature>_repository.dart
        usecases/     get_<x>.dart, create_<x>.dart
      presentation/
        bloc/         <feature>_bloc.dart, <feature>_event.dart, <feature>_state.dart
        pages/        <feature>_page.dart
        widgets/      feature-local widgets
```

## Layer contracts

**Domain**
- `entities/` — plain immutable classes, `Equatable`, no `fromJson`/`toJson`, no annotations.
- `repositories/` — abstract classes only, returning `Future<Either<Failure, T>>`.
- `usecases/` — one class, one public `call` method, one responsibility. Implements `UseCase<T, P>`.

**Data**
- `models/` — extend the domain entity, add `fromJson`/`toJson`. Models never leak past the repository implementation.
- `datasources/` — abstract interface + implementation; throw `ServerException`/`CacheException`, never return `Either`.
- `repositories/` — implement the domain contract, catch exceptions, map them to `Failure`.

**Presentation**
- `bloc/` — `sealed class` events and states with `Equatable`. State names: `<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded`, `<Feature>Error`. The BLoC depends on use cases only, never on repositories or data sources.
- `pages/` — provide the BLoC via `BlocProvider`, keep build methods thin.
- `widgets/` — presentational; extract any widget subtree over ~40 lines into its own file.

## Clean code standards

- Files, folders: `snake_case`. Classes: `PascalCase`. Members/vars: `lowerCamelCase`. Private members prefixed with `_`.
- One public class per file; the file name matches the class.
- `const` constructors and `const` widgets everywhere possible; `final` for every field and local that is not reassigned.
- Explicit return types on every function; no `dynamic` unless unavoidable.
- No magic numbers or raw strings in widgets — put them in `core/constants/`.
- Guard clauses and early returns instead of nested `if`s. Max nesting depth 3.
- Functions stay short and single-purpose; no widget-returning `_buildX()` methods — create a widget class instead.
- No `print`; no `!` null assertion where a null check works; no `late` unless the initialization is guaranteed.
- Dependencies are injected through constructors, resolved from `core/di/`. No service locator calls inside widgets or BLoCs.
- Every error path is handled — no empty `catch` blocks, no swallowed exceptions.

## Adding a feature

1. `lib/features/<feature>/` with the three layers above.
2. Domain first: entity → repository interface → use cases.
3. Data second: model → data source → repository implementation.
4. Presentation last: bloc → page → widgets.
5. Register dependencies in `core/di/`.
6. Add the route in `app/app_router.dart`.

## Current state

- Built: splash, phone entry, SMS code, welcome. `features/home` is a placeholder page.
- The auth backend does not exist yet. `SimulatedAuthRemoteDataSource` fakes it with ~900 ms latency and accepts the code `1234`. Replace it with a real `AuthRemoteDataSource` implementation; nothing above the data layer changes.
- The session is persisted with `shared_preferences` under the key `auth.session`; the splash reads it and routes to home or phone entry.
- Brand: Plus Jakarta Sans (bundled), accent `#E8622C` light / `#FF7038` dark, background `#FAF6EF` / `#131211`. The Android launch screen mirrors the Flutter splash (`res/drawable*/launch_background.xml`) so there is no white flash.

## Commands

```bash
flutter pub get
flutter analyze
flutter test
dart format lib test
flutter run
```

`flutter analyze` must be clean before any change is considered done.
