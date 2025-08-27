import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum ConvertButtonState {
  idle,
  pressed,
  loading,
  success,
  error,
}

class AnimatedConvertButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final ConvertButtonState state;
  final String? errorMessage;

  const AnimatedConvertButton({
    super.key,
    this.onPressed,
    this.state = ConvertButtonState.idle,
    this.errorMessage,
  });

  @override
  State<AnimatedConvertButton> createState() => _AnimatedConvertButtonState();
}

class _AnimatedConvertButtonState extends State<AnimatedConvertButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _loadingController;
  late AnimationController _successController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedConvertButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.state != oldWidget.state) {
      _handleStateChange();
    }
  }

  void _handleStateChange() {
    switch (widget.state) {
      case ConvertButtonState.idle:
        _pressController.reverse();
        _loadingController.stop();
        _loadingController.reset();
        _successController.reset();
        break;
      case ConvertButtonState.pressed:
        _pressController.forward();
        break;
      case ConvertButtonState.loading:
        _pressController.reverse();
        _loadingController.repeat();
        break;
      case ConvertButtonState.success:
        _loadingController.stop();
        _successController.forward();
        break;
      case ConvertButtonState.error:
        _pressController.reverse();
        _loadingController.stop();
        _loadingController.reset();
        break;
    }
  }

  Widget _buildButtonContent() {
    // Handle disabled state
    if (widget.onPressed == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.currency_exchange,
            color: Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Convert',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }
    
    switch (widget.state) {
      case ConvertButtonState.idle:
      case ConvertButtonState.pressed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.currency_exchange,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Convert',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      case ConvertButtonState.loading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Converting...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      case ConvertButtonState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            )
                .animate(controller: _successController)
                .scale(begin: const Offset(0, 0), end: const Offset(1, 1))
                .then()
                .shake(duration: 200.ms),
            const SizedBox(width: 12),
            const Text(
              'Success!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      case ConvertButtonState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
    }
  }

  Color _getButtonColor() {
    // If onPressed is null, button is disabled
    if (widget.onPressed == null) {
      return Colors.grey[400]!;
    }
    
    switch (widget.state) {
      case ConvertButtonState.idle:
      case ConvertButtonState.pressed:
      case ConvertButtonState.loading:
        return Colors.blue[600]!;
      case ConvertButtonState.success:
        return Colors.green[600]!;
      case ConvertButtonState.error:
        return Colors.red[600]!;
    }
  }

  double _getButtonHeight() {
    switch (widget.state) {
      case ConvertButtonState.pressed:
        return 56;
      case ConvertButtonState.success:
        return 65;
      default:
        return 60;
    }
  }

  double _getBorderRadius() {
    switch (widget.state) {
      case ConvertButtonState.success:
        return 20;
      case ConvertButtonState.error:
        return 12;
      default:
        return 16;
    }
  }

  double _getShadowBlur() {
    switch (widget.state) {
      case ConvertButtonState.pressed:
        return 4;
      case ConvertButtonState.success:
        return 12;
      case ConvertButtonState.error:
        return 6;
      default:
        return 8;
    }
  }

  double _getShadowOffset() {
    switch (widget.state) {
      case ConvertButtonState.pressed:
        return 2;
      case ConvertButtonState.success:
        return 6;
      default:
        return 4;
    }
  }

  double _getShadowSpread() {
    switch (widget.state) {
      case ConvertButtonState.success:
        return 2;
      default:
        return 0;
    }
  }

  Border? _getBorder() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    switch (widget.state) {
      case ConvertButtonState.error:
        return Border.all(color: Colors.red[300]!, width: 2);
      case ConvertButtonState.success:
        return Border.all(color: Colors.green[300]!, width: 1);
      default:
        // Add thin blue border in dark mode for idle/pressed states
        if (isDarkMode && widget.onPressed != null) {
          return Border.all(color: const Color(0xFF64B5F6), width: 1);
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                width: double.infinity,
                height: _getButtonHeight(),
                decoration: BoxDecoration(
                  color: _getButtonColor(),
                  borderRadius: BorderRadius.circular(_getBorderRadius()),
                  boxShadow: [
                    BoxShadow(
                      color: _getButtonColor().withOpacity(0.3),
                      blurRadius: _getShadowBlur(),
                      offset: Offset(0, _getShadowOffset()),
                      spreadRadius: _getShadowSpread(),
                    ),
                  ],
                  border: _getBorder(),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (widget.state == ConvertButtonState.loading || widget.onPressed == null) ? null : widget.onPressed,
                    onTapDown: (_) {
                      if (widget.state != ConvertButtonState.loading && widget.onPressed != null) {
                        _pressController.forward();
                      }
                    },
                    onTapUp: (_) {
                      if (widget.state != ConvertButtonState.loading && widget.onPressed != null) {
                        _pressController.reverse();
                      }
                    },
                    onTapCancel: () {
                      if (widget.state != ConvertButtonState.loading && widget.onPressed != null) {
                        _pressController.reverse();
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: _buildButtonContent(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        // Error message
        if (widget.state == ConvertButtonState.error && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .slideY(begin: -0.5, duration: 300.ms)
              .fadeIn(duration: 300.ms),
      ],
    );
  }
} 