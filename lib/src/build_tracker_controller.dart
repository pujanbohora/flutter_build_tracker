import 'package:flutter/material.dart';
import 'build_stats.dart';

/// Controller class that provides access to build statistics
/// and allows external components to monitor build activity.
class BuildTrackerController extends ChangeNotifier {
  final Map<String, BuildStats> _statsMap = {};

  /// Get a map of all tracked widget statistics
  Map<String, BuildStats> get allStats => Map.unmodifiable(_statsMap);

  /// Get statistics for a specific widget by name
  BuildStats? getStats(String name) => _statsMap[name];

  /// Update statistics for a specific widget
  void updateStats(String name, BuildStats stats) {
    _statsMap[name] = stats;
    notifyListeners();
  }

  /// Update build time for a specific widget
  void updateBuildTime(String name, Duration buildTime) {
    final stats = _statsMap[name];
    if (stats != null) {
      _statsMap[name] = stats.copyWith(lastBuildTime: buildTime);
      notifyListeners();
    }
  }

  /// Reset build count for a specific widget
  void resetBuildCount(String name) {
    final stats = _statsMap[name];
    if (stats != null) {
      _statsMap[name] = stats.copyWith(buildCount: 0);
      notifyListeners();
    }
  }

  /// Reset all build statistics
  void resetAll() {
    _statsMap.clear();
    notifyListeners();
  }

  /// Get a list of widgets that have exceeded their rebuild threshold
  List<String> getWidgetsExceedingThreshold() {
    return _statsMap.entries
        .where((entry) => entry.value.buildCount > entry.value.maxRebuilds)
        .map((entry) => entry.key)
        .toList();
  }
}
