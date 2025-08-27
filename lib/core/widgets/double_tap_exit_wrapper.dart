import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class DoubleTapExitWrapper extends StatefulWidget {
  final Widget child;
  const DoubleTapExitWrapper({super.key, required this.child});
  @override
  State<DoubleTapExitWrapper> createState() => _DoubleTapExitWrapperState();
}
class _DoubleTapExitWrapperState extends State<DoubleTapExitWrapper> {
  DateTime? _lastPressedAt;
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedAt == null || 
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Tap back again to exit',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return false; 
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
} 