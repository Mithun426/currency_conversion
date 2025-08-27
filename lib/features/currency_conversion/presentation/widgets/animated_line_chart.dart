import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trend_data.dart';
class AnimatedLineChart extends StatefulWidget {
  final CurrencyTrend trend;
  final double height;
  const AnimatedLineChart({
    super.key,
    required this.trend,
    this.height = 200,
  });
  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}
class _AnimatedLineChartState extends State<AnimatedLineChart>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late AnimationController _pointsController;
  late Animation<double> _lineAnimation;
  late Animation<double> _pointsAnimation;
  int? _selectedPointIndex;
  Offset? _tooltipPosition;
  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pointsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _lineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeInOutCubic,
    ));
    _pointsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pointsController,
      curve: Curves.elasticOut,
    ));
    _lineController.forward().then((_) {
      _pointsController.forward();
    });
  }
  @override
  void dispose() {
    _lineController.dispose();
    _pointsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: (_) => _hideTooltip(),
            child: CustomPaint(
              size: Size.infinite,
              painter: LineChartPainter(
                trend: widget.trend,
                lineAnimation: _lineAnimation,
                pointsAnimation: _pointsAnimation,
                selectedPointIndex: _selectedPointIndex,
                isDarkMode: isDarkMode,
              ),
            ),
          ),
          if (_tooltipPosition != null && _selectedPointIndex != null)
            _buildTooltip(),
        ],
      ),
    );
  }
  void _handleTapDown(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = details.localPosition;
    final chartWidth = renderBox.size.width - 32; 
    final pointSpacing = chartWidth / (widget.trend.points.length - 1);
    for (int i = 0; i < widget.trend.points.length; i++) {
      final pointX = 16 + (i * pointSpacing); 
      if ((localPosition.dx - pointX).abs() < 20) { 
        setState(() {
          _selectedPointIndex = i;
          _tooltipPosition = Offset(pointX, localPosition.dy - 60);
        });
        break;
      }
    }
  }
  void _hideTooltip() {
    setState(() {
      _selectedPointIndex = null;
      _tooltipPosition = null;
    });
  }
  Widget _buildTooltip() {
    if (_selectedPointIndex == null) return const SizedBox.shrink();
    final point = widget.trend.points[_selectedPointIndex!];
    final dateFormat = DateFormat('MMM dd');
    return Positioned(
      left: _tooltipPosition!.dx - 60,
      top: _tooltipPosition!.dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[800],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateFormat.format(point.date),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                point.rate.toStringAsFixed(4),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
             ).animate()
           .fadeIn(duration: const Duration(milliseconds: 200))
           .scaleXY(begin: 0.8, duration: const Duration(milliseconds: 200)),
    );
  }
}
class LineChartPainter extends CustomPainter {
  final CurrencyTrend trend;
  final Animation<double> lineAnimation;
  final Animation<double> pointsAnimation;
  final int? selectedPointIndex;
  final bool isDarkMode;
  LineChartPainter({
    required this.trend,
    required this.lineAnimation,
    required this.pointsAnimation,
    this.selectedPointIndex,
    required this.isDarkMode,
  }) : super(repaint: Listenable.merge([lineAnimation, pointsAnimation]));
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? const Color(0xFF64B5F6) : Colors.blue[600]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF64B5F6) : Colors.blue[600]!
      ..style = PaintingStyle.fill;
    final selectedPointPaint = Paint()
      ..color = isDarkMode ? const Color(0xFFFFB74D) : Colors.orange[600]!
      ..style = PaintingStyle.fill;
    final gridPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF3A3D47) : Colors.grey[300]!
      ..strokeWidth = 0.5;
    final chartWidth = size.width - 32; 
    final chartHeight = size.height - 32;
    final left = 16.0;
    final top = 16.0;
    _drawGrid(canvas, size, gridPaint, left, top, chartWidth, chartHeight);
    final points = _calculatePoints(left, top, chartWidth, chartHeight);
    _drawLine(canvas, points, paint);
    _drawPoints(canvas, points, pointPaint, selectedPointPaint);
  }
  void _drawGrid(Canvas canvas, Size size, Paint gridPaint, double left, 
                 double top, double chartWidth, double chartHeight) {
    for (int i = 0; i <= 4; i++) {
      final y = top + (i * chartHeight / 4);
      canvas.drawLine(
        Offset(left, y),
        Offset(left + chartWidth, y),
        gridPaint,
      );
    }
    for (int i = 0; i < trend.points.length; i++) {
      final x = left + (i * chartWidth / (trend.points.length - 1));
      canvas.drawLine(
        Offset(x, top),
        Offset(x, top + chartHeight),
        gridPaint,
      );
    }
  }
  List<Offset> _calculatePoints(double left, double top, double chartWidth, double chartHeight) {
    final points = <Offset>[];
    final minRate = trend.minRate;
    final maxRate = trend.maxRate;
    final rateRange = maxRate - minRate;
    for (int i = 0; i < trend.points.length; i++) {
      final x = left + (i * chartWidth / (trend.points.length - 1));
      final normalizedRate = (trend.points[i].rate - minRate) / rateRange;
      final y = top + chartHeight - (normalizedRate * chartHeight);
      points.add(Offset(x, y));
    }
    return points;
  }
  void _drawLine(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) / 3,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        points[i].dx - (points[i].dx - points[i - 1].dx) / 3,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final animatedPath = pathMetric.extractPath(
      0.0,
      pathMetric.length * lineAnimation.value,
    );
    canvas.drawPath(animatedPath, paint);
  }
  void _drawPoints(Canvas canvas, List<Offset> points, Paint pointPaint, Paint selectedPointPaint) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final radius = selectedPointIndex == i ? 6.0 : 4.0;
      final paint = selectedPointIndex == i ? selectedPointPaint : pointPaint;
      final animatedRadius = radius * pointsAnimation.value;
      final animatedPaint = Paint()
        ..color = paint.color.withOpacity(pointsAnimation.value)
        ..style = paint.style;
      canvas.drawCircle(point, animatedRadius, animatedPaint);
      if (selectedPointIndex == i && pointsAnimation.value > 0.5) {
        canvas.drawCircle(
          point,
          2.0 * pointsAnimation.value,
          Paint()..color = Colors.white,
        );
      }
    }
  }
  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.trend != trend ||
           oldDelegate.selectedPointIndex != selectedPointIndex;
  }
} 