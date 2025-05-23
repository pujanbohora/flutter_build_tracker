import 'package:flutter/material.dart';

/// A widget that displays build statistics as an overlay badge
class BuildTrackerOverlay extends StatelessWidget {
  /// Number of times the widget has been built
  final int buildCount;
  
  /// Duration of the last build operation
  final Duration buildTime;
  
  /// Maximum number of rebuilds before warning is triggered
  final int maxRebuilds;
  
  /// Color of the overlay badge when below rebuild threshold
  final Color normalColor;
  
  /// Color of the overlay badge when exceeding rebuild threshold
  final Color warningColor;

  const BuildTrackerOverlay({
    Key? key,
    required this.buildCount,
    required this.buildTime,
    required this.maxRebuilds,
    required this.normalColor,
    required this.warningColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exceededThreshold = buildCount > maxRebuilds;
    final color = exceededThreshold ? warningColor : normalColor;
    final timeInMs = buildTime.inMicroseconds / 1000.0;
    
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$buildCount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            '${timeInMs.toStringAsFixed(2)}ms',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
