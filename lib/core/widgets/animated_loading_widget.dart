import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum LoadingStyle {
  pulsing,
  rotating,
  bouncing,
  ripple,
  threeDots,
}

class AnimatedLoadingWidget extends StatelessWidget {
  final String? message;
  final LoadingStyle style;
  final Color? color;
  final double size;

  const AnimatedLoadingWidget({
    super.key,
    this.message,
    this.style = LoadingStyle.pulsing,
    this.color,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingAnimation(effectiveColor),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(begin: 0.2, duration: 400.ms, delay: 300.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation(Color color) {
    switch (style) {
      case LoadingStyle.pulsing:
        return _buildPulsingAnimation(color);
      case LoadingStyle.rotating:
        return _buildRotatingAnimation(color);
      case LoadingStyle.bouncing:
        return _buildBouncingAnimation(color);
      case LoadingStyle.ripple:
        return _buildRippleAnimation(color);
      case LoadingStyle.threeDots:
        return _buildThreeDotsAnimation(color);
    }
  }

  Widget _buildPulsingAnimation(Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Icon(
        Icons.currency_exchange,
        size: size * 0.5,
        color: Colors.white,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.2, 1.2),
        duration: 1000.ms,
        curve: Curves.easeInOut,
      )
      .then()
      .scale(
        begin: const Offset(1.2, 1.2),
        end: const Offset(0.8, 0.8),
        duration: 1000.ms,
        curve: Curves.easeInOut,
      );
  }

  Widget _buildRotatingAnimation(Color color) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Outer ring
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 4,
              ),
            ),
          ),
          // Inner rotating ring
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.transparent,
                width: 4,
              ),
              gradient: SweepGradient(
                colors: [
                  color,
                  color.withOpacity(0.1),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 2000.ms),
          // Center icon
          Center(
            child: Icon(
              Icons.currency_exchange,
              size: size * 0.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingAnimation(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: size / 4,
          height: size / 4,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
          .moveY(
            begin: 0,
            end: -20,
            duration: 600.ms,
            delay: Duration(milliseconds: index * 200),
            curve: Curves.easeInOut,
          )
          .then()
          .moveY(
            begin: -20,
            end: 0,
            duration: 600.ms,
            curve: Curves.easeInOut,
          );
      }),
    );
  }

  Widget _buildRippleAnimation(Color color) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(3, (index) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.6 - (index * 0.2)),
                width: 2,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(0.0, 0.0),
              end: const Offset(1.0, 1.0),
              duration: 2000.ms,
              delay: Duration(milliseconds: index * 400),
            )
            .fadeIn(
              begin: 1.0,
              duration: 2000.ms,
              delay: Duration(milliseconds: index * 400),
            );
        }),
      ),
    );
  }

  Widget _buildThreeDotsAnimation(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.5, 1.5),
            duration: 600.ms,
            delay: Duration(milliseconds: index * 200),
          )
          .then()
          .scale(
            begin: const Offset(1.5, 1.5),
            end: const Offset(1.0, 1.0),
            duration: 600.ms,
          );
      }),
    );
  }
} 