import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/trend_data.dart';
class TrendStatisticsChips extends StatelessWidget {
  final CurrencyTrend trend;
  const TrendStatisticsChips({
    super.key,
    required this.trend,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatChip(
          'MIN',
          trend.minRate.toStringAsFixed(4),
          isDarkMode ? const Color(0xFFFF5252).withOpacity(0.2) : Colors.red[100]!,
          isDarkMode ? const Color(0xFFFF5252) : Colors.red[600]!,
          0,
          isDarkMode,
        ),
        _buildStatChip(
          'AVG',
          trend.avgRate.toStringAsFixed(4),
          isDarkMode ? const Color(0xFF64B5F6).withOpacity(0.2) : Colors.blue[100]!,
          isDarkMode ? const Color(0xFF64B5F6) : Colors.blue[600]!,
          100,
          isDarkMode,
        ),
        _buildStatChip(
          'MAX',
          trend.maxRate.toStringAsFixed(4),
          isDarkMode ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.green[100]!,
          isDarkMode ? const Color(0xFF4CAF50) : Colors.green[600]!,
          200,
          isDarkMode,
        ),
      ],
    );
  }
  Widget _buildStatChip(String label, String value, Color bgColor, Color textColor, int delay, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: const Duration(milliseconds: 400), delay: Duration(milliseconds: delay))
        .slideY(begin: 0.3, duration: const Duration(milliseconds: 400), delay: Duration(milliseconds: delay));
  }
} 