import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NetworkErrorWidget extends StatefulWidget {
  final VoidCallback? onRetry;
  final String? customMessage;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  State<NetworkErrorWidget> createState() => _NetworkErrorWidgetState();
}

class _NetworkErrorWidgetState extends State<NetworkErrorWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _iconController;
  late Animation<double> _waveAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _iconController.forward();
    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated WiFi Icon with Waves
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // WiFi Waves
                  ...List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) {
                        final delay = index * 0.3;
                        final waveProgress = (_waveAnimation.value - delay).clamp(0.0, 1.0);
                        return Container(
                          width: 60 + (index * 30) * waveProgress,
                          height: 60 + (index * 30) * waveProgress,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3 * (1 - waveProgress)),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  
                  // Main WiFi Icon
                  AnimatedBuilder(
                    animation: _iconAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange[100],
                            border: Border.all(
                              color: Colors.orange[300]!,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.wifi_off,
                            size: 40,
                            color: Colors.orange[600],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideY(begin: -0.3, duration: const Duration(milliseconds: 600)),
            
            const SizedBox(height: 32),
            
            // Error Title
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
              textAlign: TextAlign.center,
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 800)),
            
            const SizedBox(height: 16),
            
            // Error Message
            Text(
              widget.customMessage ?? 
              'Please check your internet connection and try again.',
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
            
            // Retry Button
            if (widget.onRetry != null)
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
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
              ).animate()
                  .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 600))
                  .slideY(begin: 0.5, duration: const Duration(milliseconds: 600))
                  .then()
                  .shimmer(duration: const Duration(milliseconds: 1000)),
            
            const SizedBox(height: 32),
            
            // Connection Status Indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Make sure WiFi or mobile data is enabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 800), delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.3, duration: const Duration(milliseconds: 800)),
          ],
        ),
      ),
    );
  }
} 