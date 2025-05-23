import 'package:flutter/material.dart';
import 'build_stats.dart';
import 'build_tracker_controller.dart';
import 'build_tracker_overlay.dart';

/// A widget that tracks build counts and times for its child widget.
///
/// Wraps a child widget and monitors how many times it rebuilds and how long
/// each build takes. Can display warnings when rebuild count exceeds a threshold.
class BuildTracker extends StatefulWidget {
  /// The widget to track builds for
  final Widget child;
  
  /// A unique identifier for this tracked widget
  final String? name;
  
  /// Maximum number of rebuilds before warning is triggered
  final int maxRebuilds;
  
  /// Whether to show an overlay badge with build information
  final bool showOverlay;
  
  /// Whether to log build information to the console
  final bool logToConsole;
  
  /// Custom controller to access build statistics
  final BuildTrackerController? controller;
  
  /// Position of the overlay badge
  final Alignment overlayAlignment;
  
  /// Color of the overlay badge when below rebuild threshold
  final Color normalColor;
  
  /// Color of the overlay badge when exceeding rebuild threshold
  final Color warningColor;

  const BuildTracker({
    Key? key,
    required this.child,
    this.name,
    this.maxRebuilds = 10,
    this.showOverlay = true,
    this.logToConsole = true,
    this.controller,
    this.overlayAlignment = Alignment.topRight,
    this.normalColor = Colors.blue,
    this.warningColor = Colors.red,
  }) : super(key: key);

  @override
  State<BuildTracker> createState() => _BuildTrackerState();
}

class _BuildTrackerState extends State<BuildTracker> {
  late final String _name;
  late final BuildTrackerController _controller;
  int _buildCount = 0;
  Duration _lastBuildTime = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _name = widget.name ?? widget.child.runtimeType.toString();
    _controller = widget.controller ?? BuildTrackerController();
  }

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    // Increment build count
    _buildCount++;
    
    // Create or update build stats
    final stats = BuildStats(
      name: _name,
      buildCount: _buildCount,
      lastBuildTime: _lastBuildTime,
      maxRebuilds: widget.maxRebuilds,
    );
    
    // Update controller with latest stats
    _controller.updateStats(_name, stats);
    
    // Log to console if enabled
    if (widget.logToConsole) {
      final exceededThreshold = _buildCount > widget.maxRebuilds;
      final prefix = exceededThreshold ? '⚠️ ' : '';
      print('$prefix[$_name] Build #$_buildCount, Last build: ${_lastBuildTime.inMicroseconds}μs');
      
      if (exceededThreshold && _buildCount == widget.maxRebuilds + 1) {
        print('⚠️ [$_name] Exceeded maximum rebuild count (${widget.maxRebuilds})');
      }
    }
    
    return Stack(
      children: [
        Builder(
          builder: (context) {
            // Measure build time after child is built
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _lastBuildTime = stopwatch.elapsed;
              _controller.updateBuildTime(_name, _lastBuildTime);
              
              if (mounted) {
                setState(() {});
              }
            });
            
            return widget.child;
          },
        ),
        
        // Show overlay badge if enabled
        if (widget.showOverlay)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: widget.overlayAlignment,
                child: BuildTrackerOverlay(
                  buildCount: _buildCount,
                  buildTime: _lastBuildTime,
                  maxRebuilds: widget.maxRebuilds,
                  normalColor: widget.normalColor,
                  warningColor: widget.warningColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
