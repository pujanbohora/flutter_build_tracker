/// Class to store build statistics for a tracked widget
class BuildStats {
  /// Unique identifier for the tracked widget
  final String name;
  
  /// Number of times the widget has been built
  final int buildCount;
  
  /// Duration of the last build operation
  final Duration lastBuildTime;
  
  /// Maximum number of rebuilds before warning is triggered
  final int maxRebuilds;

  const BuildStats({
    required this.name,
    required this.buildCount,
    required this.lastBuildTime,
    required this.maxRebuilds,
  });

  /// Create a copy of this BuildStats with updated values
  BuildStats copyWith({
    String? name,
    int? buildCount,
    Duration? lastBuildTime,
    int? maxRebuilds,
  }) {
    return BuildStats(
      name: name ?? this.name,
      buildCount: buildCount ?? this.buildCount,
      lastBuildTime: lastBuildTime ?? this.lastBuildTime,
      maxRebuilds: maxRebuilds ?? this.maxRebuilds,
    );
  }

  /// Check if the widget has exceeded its rebuild threshold
  bool get hasExceededThreshold => buildCount > maxRebuilds;

  /// Get the build time in milliseconds
  double get buildTimeMs => lastBuildTime.inMicroseconds / 1000;

  /// Get the build time in microseconds
  int get buildTimeUs => lastBuildTime.inMicroseconds;

  @override
  String toString() => 'BuildStats(name: $name, count: $buildCount, '
      'time: ${buildTimeUs}μs, max: $maxRebuilds)';
}
