import 'package:flutter/material.dart';

enum TransitionType {
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  fade,
  scale,
  rotation,
  ripple,
}

class AnimatedPageTransition extends PageRouteBuilder {
  final Widget child;
  final TransitionType transitionType;
  final Duration duration;
  final Curve curve;

  AnimatedPageTransition({
    required this.child,
    this.transitionType = TransitionType.slideUp,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              child,
              animation,
              secondaryAnimation,
              transitionType,
              curve,
            );
          },
        );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    TransitionType type,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (type) {
      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case TransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case TransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case TransitionType.ripple:
        return AnimatedBuilder(
          animation: curvedAnimation,
          child: child,
          builder: (context, child) {
            return ClipPath(
              clipper: CircleRevealClipper(
                fraction: curvedAnimation.value,
                centerAlignment: Alignment.center,
              ),
              child: child,
            );
          },
        );
    }
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment? centerAlignment;

  CircleRevealClipper({
    required this.fraction,
    this.centerAlignment,
  });

  @override
  Path getClip(Size size) {
    final center = centerAlignment?.alongSize(size) ?? 
        Offset(size.width / 2, size.height / 2);
    final radius = fraction * size.longestSide;
    
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}

// Helper extension for easy navigation
extension AnimatedNavigation on BuildContext {
  Future<T?> pushAnimated<T extends Object?>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).push<T>(
      AnimatedPageTransition(
        child: page,
        transitionType: transition,
        duration: duration,
        curve: curve,
      ) as Route<T>,
    );
  }

  Future<T?> pushReplacementAnimated<T extends Object?, TO extends Object?>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      AnimatedPageTransition(
        child: page,
        transitionType: transition,
        duration: duration,
        curve: curve,
      ) as Route<T>,
    );
  }
} 