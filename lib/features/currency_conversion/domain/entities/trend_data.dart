import 'package:equatable/equatable.dart';

class TrendPoint extends Equatable {
  final DateTime date;
  final double rate;

  const TrendPoint({
    required this.date,
    required this.rate,
  });

  @override
  List<Object> get props => [date, rate];
}

class CurrencyTrend extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final List<TrendPoint> points;
  final double minRate;
  final double maxRate;
  final double avgRate;
  final double currentRate;
  final double changePercent;

  const CurrencyTrend({
    required this.fromCurrency,
    required this.toCurrency,
    required this.points,
    required this.minRate,
    required this.maxRate,
    required this.avgRate,
    required this.currentRate,
    required this.changePercent,
  });

  @override
  List<Object> get props => [
        fromCurrency,
        toCurrency,
        points,
        minRate,
        maxRate,
        avgRate,
        currentRate,
        changePercent,
      ];

  // Generate mock trend data for any currency pair
  static CurrencyTrend generateMockTrend(String from, String to) {
    final now = DateTime.now();
    final points = <TrendPoint>[];
    
    // Base rate for the currency pair
    final baseRate = _getBaseRate(from, to);
    
    // Generate 5 days of mock data with realistic fluctuations
    for (int i = 4; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final variation = (i - 2) * 0.02 + (i.isEven ? 0.01 : -0.01);
      final rate = baseRate * (1 + variation + (_randomVariation() * 0.005));
      
      points.add(TrendPoint(
        date: date,
        rate: rate,
      ));
    }
    
    final rates = points.map((p) => p.rate).toList();
    final minRate = rates.reduce((a, b) => a < b ? a : b);
    final maxRate = rates.reduce((a, b) => a > b ? a : b);
    final avgRate = rates.reduce((a, b) => a + b) / rates.length;
    final currentRate = rates.last;
    final firstRate = rates.first;
    final changePercent = ((currentRate - firstRate) / firstRate) * 100;
    
    return CurrencyTrend(
      fromCurrency: from,
      toCurrency: to,
      points: points,
      minRate: minRate,
      maxRate: maxRate,
      avgRate: avgRate,
      currentRate: currentRate,
      changePercent: changePercent,
    );
  }
  
  static double _getBaseRate(String from, String to) {
    // Mock base rates for common currency pairs
    final pair = '$from$to';
    switch (pair) {
      case 'USDEUR': return 0.85;
      case 'EURUSD': return 1.18;
      case 'USDJPY': return 148.0;
      case 'JPYUSD': return 0.0067;
      case 'GBPUSD': return 1.27;
      case 'USDGBP': return 0.79;
      case 'USDCAD': return 1.35;
      case 'CADUSD': return 0.74;
      case 'AUDPUSD': return 0.66;
      case 'USDAUD': return 1.52;
      case 'USDCHF': return 0.88;
      case 'CHFUSD': return 1.14;
      case 'USDCNY': return 7.15;
      case 'CNYUSD': return 0.14;
      case 'USDINR': return 83.2;
      case 'INRUSD': return 0.012;
      default:
        // Generate a reasonable rate based on currency codes
        return _generateReasonableRate(from, to);
    }
  }
  
  static double _generateReasonableRate(String from, String to) {
    final fromCode = from.hashCode.abs() % 1000;
    final toCode = to.hashCode.abs() % 1000;
    final ratio = (fromCode + 1) / (toCode + 1);
    
    if (ratio > 1) {
      return ratio;
    } else {
      return ratio * 100; // Adjust for smaller currency units
    }
  }
  
  static double _randomVariation() {
    // Simple pseudo-random for consistent mock data
    return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0 - 0.5;
  }
} 