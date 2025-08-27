import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class AnimatedSuccessWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Duration duration;
  const AnimatedSuccessWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.duration = const Duration(milliseconds: 2000),
  });
  @override
  State<AnimatedSuccessWidget> createState() => _AnimatedSuccessWidgetState();
}
class _AnimatedSuccessWidgetState extends State<AnimatedSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[400]!,
              Colors.green[600]!,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ...List.generate(8, (index) {
                  final angle = (index * 45.0) * 3.14159 / 180;
                  return Transform.translate(
                    offset: Offset(
                      30 * (index % 2 == 0 ? 1 : -1),
                      30 * (index % 4 < 2 ? 1 : -1),
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        shape: BoxShape.circle,
                      ),
                    ).animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        delay: Duration(milliseconds: 200 + (index * 50)),
                      )
                      .fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: 200 + (index * 50)),
                      )
                      .then()
                      .fadeOut(duration: 500.ms),
                  );
                }),
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _checkAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: CheckmarkPainter(
                                progress: _checkAnimation.value,
                                color: Colors.green[600]!,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.3, duration: 400.ms, delay: 400.ms),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.subtitle!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ).animate()
                .fadeIn(duration: 600.ms, delay: 600.ms)
                .slideY(begin: 0.2, duration: 400.ms, delay: 600.ms),
            ],
          ],
        ),
      ),
    );
  }
}
class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  CheckmarkPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final checkmarkPath = Path();
    final startPoint = Offset(center.dx - 12, center.dy);
    final middlePoint = Offset(center.dx - 2, center.dy + 10);
    final endPoint = Offset(center.dx + 12, center.dy - 8);
    if (progress > 0) {
      checkmarkPath.moveTo(startPoint.dx, startPoint.dy);
      if (progress <= 0.5) {
        final currentPoint = Offset.lerp(
          startPoint,
          middlePoint,
          progress * 2,
        )!;
        checkmarkPath.lineTo(currentPoint.dx, currentPoint.dy);
      } else {
        checkmarkPath.lineTo(middlePoint.dx, middlePoint.dy);
        final currentPoint = Offset.lerp(
          middlePoint,
          endPoint,
          (progress - 0.5) * 2,
        )!;
        checkmarkPath.lineTo(currentPoint.dx, currentPoint.dy);
      }
    }
    canvas.drawPath(checkmarkPath, paint);
  }
  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 