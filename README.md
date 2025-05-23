# Flutter Build Tracker

A Flutter package to track widget build counts and times for performance optimization and debugging.

## Features

- Count how many times a widget builds
- Track and log build time duration (microseconds/milliseconds)
- Warn if a widget exceeds a configurable maximum rebuild threshold
- Display build information in console logs and/or overlay badge
- Access build statistics programmatically via controller

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_build_tracker: ^0.1.0
```

## Usage

Wrap any widget you want to track with `BuildTracker`:

```dart
BuildTracker(
  name: 'MyWidget', // Optional name for identification
  maxRebuilds: 5, // Warn after 5 rebuilds
  showOverlay: true, // Show overlay badge
  logToConsole: true, // Log to console
  child: YourWidget(),
)
```

### Advanced Usage with Controller

Use a controller to access build statistics programmatically:

```dart
final controller = BuildTrackerController();

// In your widget tree
BuildTracker(
  name: 'MyWidget',
  controller: controller,
  child: YourWidget(),
)

// Later, access statistics
final stats = controller.getStats('MyWidget');
print('Build count: ${stats?.buildCount}');
print('Last build time: ${stats?.buildTimeMs}ms');

// Reset build counts
controller.resetBuildCount('MyWidget');
// or
controller.resetAll();

// Get widgets exceeding threshold
final problematicWidgets = controller.getWidgetsExceedingThreshold();
```

## Customization

You can customize the appearance and behavior:

```dart
BuildTracker(
  name: 'MyWidget',
  maxRebuilds: 10,
  showOverlay: true,
  logToConsole: true,
  overlayAlignment: Alignment.topRight, // Position of overlay badge
  normalColor: Colors.blue, // Color when below threshold
  warningColor: Colors.red, // Color when exceeding threshold
  child: YourWidget(),
)
```

## Example

See the `example` directory for a complete sample application.

## Performance Considerations

The BuildTracker itself adds a small overhead to your application. It's recommended to:

1. Use it only in debug builds
2. Remove it from production code
3. Focus on tracking widgets that you suspect have performance issues
# flutter_build_tracker
