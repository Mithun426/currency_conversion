import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum ErrorType {
  server,
  network,
  api,
  timeout,
  unknown,
}

class AnimatedErrorWidget extends StatefulWidget {
  final String message;
  final ErrorType errorType;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final bool showRetryButton;
  final bool showBackButton;

  const AnimatedErrorWidget({
    super.key,
    required this.message,
    this.errorType = ErrorType.unknown,
    this.onRetry,
    this.onGoBack,
    this.showRetryButton = true,
    this.showBackButton = false,
  });

  @override
  State<AnimatedErrorWidget> createState() => _AnimatedErrorWidgetState();
}

class _AnimatedErrorWidgetState extends State<AnimatedErrorWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _bounceController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the main icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shake animation for severe errors
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    // Bounce animation for buttons
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    // Start pulse animation
    _pulseController.repeat(reverse: true);
    
    // Shake for severe errors
    if (widget.errorType == ErrorType.server || widget.errorType == ErrorType.api) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _shakeController.forward().then((_) {
            _shakeController.reverse();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  IconData _getErrorIcon() {
    switch (widget.errorType) {
      case ErrorType.server:
        return Icons.dns_outlined;
      case ErrorType.network:
        return Icons.wifi_off_outlined;
      case ErrorType.api:
        return Icons.api_outlined;
      case ErrorType.timeout:
        return Icons.access_time_outlined;
      case ErrorType.unknown:
      default:
        return Icons.error_outline;
    }
  }

  Color _getErrorColor() {
    switch (widget.errorType) {
      case ErrorType.server:
        return Colors.red[600]!;
      case ErrorType.network:
        return Colors.orange[600]!;
      case ErrorType.api:
        return Colors.purple[600]!;
      case ErrorType.timeout:
        return Colors.amber[700]!;
      case ErrorType.unknown:
      default:
        return Colors.grey[600]!;
    }
  }

  String _getErrorTitle() {
    switch (widget.errorType) {
      case ErrorType.server:
        return 'Server Error';
      case ErrorType.network:
        return 'Connection Problem';
      case ErrorType.api:
        return 'API Error';
      case ErrorType.timeout:
        return 'Request Timeout';
      case ErrorType.unknown:
      default:
        return 'Something Went Wrong';
    }
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getErrorColor().withOpacity(0.1),
                border: Border.all(
                  color: _getErrorColor().withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _getErrorIcon(),
                size: 60,
                color: _getErrorColor(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    if (!widget.showRetryButton || widget.onRetry == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: ElevatedButton.icon(
            onPressed: () {
              _bounceController.forward().then((_) {
                _bounceController.reverse();
                widget.onRetry!();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getErrorColor(),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 4,
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    if (!widget.showBackButton || widget.onGoBack == null) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: widget.onGoBack,
      style: OutlinedButton.styleFrom(
        foregroundColor: _getErrorColor(),
        side: BorderSide(color: _getErrorColor()),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: const Icon(Icons.arrow_back, size: 18),
      label: const Text(
        'Go Back',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Error Icon
            _buildAnimatedIcon()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideY(begin: -0.3, duration: const Duration(milliseconds: 600)),
            
            const SizedBox(height: 32),
            
            // Error Title
            Text(
              _getErrorTitle(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getErrorColor(),
              ),
              textAlign: TextAlign.center,
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 800)),
            
            const SizedBox(height: 16),
            
            // Error Message
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 1000), delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 1000)),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            Column(
              children: [
                _buildRetryButton()
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 600))
                    .slideY(begin: 0.5, duration: const Duration(milliseconds: 600)),
                
                if (widget.showBackButton && widget.showRetryButton)
                  const SizedBox(height: 16),
                
                _buildBackButton()
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 800))
                    .slideY(begin: 0.5, duration: const Duration(milliseconds: 600)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Helpful Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber[700],
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getHelpfulTip(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 1000))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 800)),
          ],
        ),
      ),
    );
  }

  String _getHelpfulTip() {
    switch (widget.errorType) {
      case ErrorType.server:
        return 'The server is currently experiencing issues. Please try again in a few moments.';
      case ErrorType.network:
        return 'Check your internet connection and make sure you\'re connected to a stable network.';
      case ErrorType.api:
        return 'There\'s an issue with the currency exchange service. This is usually temporary.';
      case ErrorType.timeout:
        return 'The request took too long to complete. Try again with a stable connection.';
      case ErrorType.unknown:
      default:
        return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
    }
  }
} 