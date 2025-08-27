import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ApiModeToggle extends StatefulWidget {
  final bool isUseMockData;
  final Function(bool) onToggle;

  const ApiModeToggle({
    super.key,
    required this.isUseMockData,
    required this.onToggle,
  });

  @override
  State<ApiModeToggle> createState() => _ApiModeToggleState();
}

class _ApiModeToggleState extends State<ApiModeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey[400],
      end: Colors.green[500],
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Set initial state
    if (widget.isUseMockData) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ApiModeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUseMockData != oldWidget.isUseMockData) {
      if (widget.isUseMockData) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => widget.onToggle(!widget.isUseMockData),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mock option
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return                          AnimatedContainer(
                         duration: const Duration(milliseconds: 300),
                         curve: Curves.easeInOutCubic,
                         padding: EdgeInsets.symmetric(
                           horizontal: widget.isUseMockData ? 14 : 12, 
                           vertical: widget.isUseMockData ? 8 : 6,
                         ),
                         decoration: BoxDecoration(
                           color: widget.isUseMockData 
                               ? Colors.orange[500] 
                               : Colors.transparent,
                           borderRadius: BorderRadius.circular(widget.isUseMockData ? 14 : 12),
                           boxShadow: widget.isUseMockData ? [
                             BoxShadow(
                               color: Colors.orange[300]!.withOpacity(0.3),
                               blurRadius: 4,
                               offset: const Offset(0, 2),
                             ),
                           ] : null,
                         ),
                        child: Text(
                          'Mock',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.isUseMockData 
                                ? Colors.white 
                                : Colors.grey[600],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 4),
                  
                  // Live option
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return                          AnimatedContainer(
                         duration: const Duration(milliseconds: 300),
                         curve: Curves.easeInOutCubic,
                         padding: EdgeInsets.symmetric(
                           horizontal: !widget.isUseMockData ? 14 : 12, 
                           vertical: !widget.isUseMockData ? 8 : 6,
                         ),
                         decoration: BoxDecoration(
                           color: !widget.isUseMockData 
                               ? Colors.green[500] 
                               : Colors.transparent,
                           borderRadius: BorderRadius.circular(!widget.isUseMockData ? 14 : 12),
                           boxShadow: !widget.isUseMockData ? [
                             BoxShadow(
                               color: Colors.green[300]!.withOpacity(0.3),
                               blurRadius: 4,
                               offset: const Offset(0, 2),
                             ),
                           ] : null,
                         ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!widget.isUseMockData)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ).animate(onPlay: (controller) => controller.repeat())
                                  .scaleXY(
                                    begin: 0.8,
                                    end: 1.2,
                                    duration: const Duration(milliseconds: 1000),
                                  ),
                            Text(
                              'Live',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: !widget.isUseMockData 
                                    ? Colors.white 
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(begin: 0.3, duration: const Duration(milliseconds: 400));
  }
} 