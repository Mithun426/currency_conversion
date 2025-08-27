import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trend_data.dart';
import '../widgets/animated_line_chart.dart';
import '../widgets/trend_statistics_chips.dart';
class TrendScreen extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;
  const TrendScreen({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
  });
  @override
  State<TrendScreen> createState() => _TrendScreenState();
}
class _TrendScreenState extends State<TrendScreen> {
  late CurrencyTrend trend;
  @override
  void initState() {
    super.initState();
    trend = CurrencyTrend.generateMockTrend(widget.fromCurrency, widget.toCurrency);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1D23) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3A3D47) : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate()
              .fadeIn(duration: const Duration(milliseconds: 200)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.fromCurrency} to ${widget.toCurrency}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? const Color(0xFFE3F2FD) : Colors.black,
                      ),
                    ),
                    Text(
                      '5-Day Trend',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? const Color(0xFFB0BEC5) : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: trend.changePercent >= 0 
                        ? (isDarkMode ? const Color(0xFF4CAF50).withOpacity(0.2) : Colors.green[100])
                        : (isDarkMode ? const Color(0xFFFF5252).withOpacity(0.2) : Colors.red[100]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trend.changePercent >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: trend.changePercent >= 0 
                            ? (isDarkMode ? const Color(0xFF4CAF50) : Colors.green[600])
                            : (isDarkMode ? const Color(0xFFFF5252) : Colors.red[600]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trend.changePercent >= 0 ? '+' : ''}${trend.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: trend.changePercent >= 0 
                              ? (isDarkMode ? const Color(0xFF4CAF50) : Colors.green[600])
                              : (isDarkMode ? const Color(0xFFFF5252) : Colors.red[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate()
              .fadeIn(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 100))
              .slideX(begin: -0.3, duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 100)),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Rate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trend.currentRate.toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.show_chart,
                  size: 32,
                  color: Colors.blue[600],
                ),
              ],
            ),
          ).animate()
              .fadeIn(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.3, duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: AnimatedLineChart(
                trend: trend,
                height: 200,
              ),
            ).animate()
                .fadeIn(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400))
                .scaleXY(begin: 0.95, duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TrendStatisticsChips(trend: trend),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM dd').format(trend.points.first.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Tap chart points for details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  DateFormat('MMM dd').format(trend.points.last.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).animate()
              .fadeIn(duration: const Duration(milliseconds: 400), delay: const Duration(milliseconds: 800)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  static void show(BuildContext context, String fromCurrency, String toCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrendScreen(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      ),
    );
  }
} 