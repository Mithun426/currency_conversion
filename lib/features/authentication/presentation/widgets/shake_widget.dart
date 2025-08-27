import 'package:flutter/material.dart';
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });
  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}
class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void shake() {
    _controller.forward().then((_) {
      _controller.reset();
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final offset = _animation.value * 10 * 
            (0.5 - (_animation.value * 2 - 1).abs());
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
    );
  }
} 