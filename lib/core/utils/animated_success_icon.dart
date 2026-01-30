import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated success icon widget with circular background and checkmark
/// Features: scale animation, checkmark draw, and ripple effect
class AnimatedSuccessIcon extends StatefulWidget {
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback? onComplete;
  final bool repeat;
  final Duration? pauseBetweenRepeats;

  const AnimatedSuccessIcon({
    Key? key,
    this.size = 120.0,
    this.iconColor = Colors.white,
    this.backgroundColor = const Color(0xFF4CAF50), // Green
    this.duration = const Duration(milliseconds: 1500),
    this.onComplete,
    this.repeat = true,
    this.pauseBetweenRepeats = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<AnimatedSuccessIcon> createState() => _AnimatedSuccessIconState();
}

class _AnimatedSuccessIconState extends State<AnimatedSuccessIcon>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late AnimationController _rippleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation controller (circle appears)
    _scaleController = AnimationController(
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 0.4).round()),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Check animation controller (checkmark draws)
    _checkController = AnimationController(
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 0.3).round()),
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    // Ripple animation controller (pulse effect)
    _rippleController = AnimationController(
      duration: Duration(milliseconds: (widget.duration.inMilliseconds * 0.6).round()),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    do {
      // Reset all animations
      _scaleController.reset();
      _checkController.reset();
      _rippleController.reset();

      // Start scale animation
      await _scaleController.forward();

      // Start check and ripple animations simultaneously
      _checkController.forward();
      _rippleController.forward();

      // Wait for animations to complete
      await _checkController.forward();
      
      widget.onComplete?.call();

      // If repeating, pause before next iteration
      if (widget.repeat && mounted) {
        await Future.delayed(widget.pauseBetweenRepeats ?? Duration.zero);
      }
    } while (widget.repeat && mounted);
  }

  /// Restart the animation from the beginning
  void restart() {
    _scaleController.reset();
    _checkController.reset();
    _rippleController.reset();
    _startAnimation();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect (animated circles)
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // First ripple
                  _buildRipple(
                    scale: 1.0 + (_rippleAnimation.value * 0.5),
                    opacity: 1.0 - _rippleAnimation.value,
                  ),
                  // Second ripple (delayed)
                  _buildRipple(
                    scale: 1.0 + (_rippleAnimation.value * 0.3),
                    opacity: (1.0 - _rippleAnimation.value) * 0.6,
                  ),
                ],
              );
            },
          ),

          // Main circle with checkmark
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: CheckmarkPainter(
                    progress: _checkAnimation.value,
                    color: widget.iconColor,
                    strokeWidth: widget.size * 0.08,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRipple({required double scale, required double opacity}) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.backgroundColor.withOpacity(opacity * 0.4),
            width: 3,
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw an animated checkmark
class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Define checkmark points
    final double width = size.width;
    final double height = size.height;

    // Starting point (left side of check)
    final p1 = Offset(width * 0.25, height * 0.5);
    // Middle point (bottom of check)
    final p2 = Offset(width * 0.42, height * 0.65);
    // End point (top right of check)
    final p3 = Offset(width * 0.75, height * 0.35);

    // First segment (left to middle) - 40% of total animation
    if (progress <= 0.4) {
      final segmentProgress = progress / 0.4;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(
        p1.dx + (p2.dx - p1.dx) * segmentProgress,
        p1.dy + (p2.dy - p1.dy) * segmentProgress,
      );
    }
    // Second segment (middle to end) - remaining 60%
    else {
      final segmentProgress = (progress - 0.4) / 0.6;
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(
        p2.dx + (p3.dx - p2.dx) * segmentProgress,
        p2.dy + (p3.dy - p2.dy) * segmentProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Example usage widget showing the animated success icon
class SuccessAnimationDemo extends StatefulWidget {
  const SuccessAnimationDemo({Key? key}) : super(key: key);

  @override
  State<SuccessAnimationDemo> createState() => _SuccessAnimationDemoState();
}

class _SuccessAnimationDemoState extends State<SuccessAnimationDemo> {
  final GlobalKey<_AnimatedSuccessIconState> _iconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Success Animation Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main animated success icon
            AnimatedSuccessIcon(
              key: _iconKey,
              size: 120,
              backgroundColor: const Color(0xFF4CAF50),
              iconColor: Colors.white,
              duration: const Duration(milliseconds: 1500),
              repeat: true,
              pauseBetweenRepeats: const Duration(milliseconds: 500),
              onComplete: () {
                print('Animation cycle completed!');
              },
            ),

            const SizedBox(height: 40),

            // Success message
            const Text(
              'Your biometric security preference\nhas been set successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 60),

            // Replay button
            ElevatedButton.icon(
              onPressed: () {
                _iconKey.currentState?.restart();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Replay Animation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// To use this in your app's main.dart:
// void main() {
//   runApp(const MaterialApp(
//     home: SuccessAnimationDemo(),
//     debugShowCheckedModeBanner: false,
//   ));
// }