import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSwapButton extends StatefulWidget {
  final VoidCallback onSwap;
  final bool isEnabled;

  const AnimatedSwapButton({
    super.key,
    required this.onSwap,
    this.isEnabled = true,
  });

  @override
  State<AnimatedSwapButton> createState() => _AnimatedSwapButtonState();
}

class _AnimatedSwapButtonState extends State<AnimatedSwapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  // Removed color animation for better performance

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // 36 frames at 60fps
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1.0, // Full 360 degrees for horizontal swap
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1, // Subtle scale
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Removed color animation for better performance
    // Fixed color is used instead
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSwap() {
    if (!widget.isEnabled) return;
    
    // Quick subtle animation
    _controller.forward().then((_) {
      _controller.reverse();
    });
    
    widget.onSwap();
  }

    @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: _handleSwap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue[600], // Fixed color for better performance
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[600]!.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.swap_horiz,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, duration: 300.ms);
  }
} 