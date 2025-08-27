import 'conversion_result.dart';

class MockConversionData {
  // Generate mock conversion result for any currency pair
  static ConversionResult generateMockConversion({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    final exchangeRate = _getMockExchangeRate(fromCurrency, toCurrency);
    final convertedAmount = amount * exchangeRate;
    
    return ConversionResult(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      convertedAmount: convertedAmount,
      exchangeRate: exchangeRate,
      timestamp: DateTime.now(),
    );
  }
  
  // Mock exchange rates for common currency pairs
  static double _getMockExchangeRate(String from, String to) {
    final pair = '$from$to';
    
    // Add some realistic variation to make it feel more authentic
    final variation = _getRandomVariation();
    
    switch (pair) {
      // Major pairs
      case 'USDEUR': return (0.85 + variation * 0.02);
      case 'EURUSD': return (1.18 + variation * 0.03);
      case 'USDJPY': return (148.0 + variation * 2.0);
      case 'JPYUSD': return (0.0067 + variation * 0.0001);
      case 'GBPUSD': return (1.27 + variation * 0.02);
      case 'USDGBP': return (0.79 + variation * 0.015);
      case 'USDCAD': return (1.35 + variation * 0.02);
      case 'CADUSD': return (0.74 + variation * 0.01);
      case 'AUDPUSD': return (0.66 + variation * 0.015);
      case 'USDAUD': return (1.52 + variation * 0.03);
      case 'USDCHF': return (0.88 + variation * 0.015);
      case 'CHFUSD': return (1.14 + variation * 0.02);
      
      // Asian pairs
      case 'USDCNY': return (7.15 + variation * 0.1);
      case 'CNYUSD': return (0.14 + variation * 0.002);
      case 'USDINR': return (83.2 + variation * 1.0);
      case 'INRUSD': return (0.012 + variation * 0.0002);
      case 'USDKRW': return (1320.0 + variation * 20.0);
      case 'KRWUSD': return (0.00076 + variation * 0.00001);
      case 'USDSGD': return (1.34 + variation * 0.02);
      case 'SGDUSD': return (0.75 + variation * 0.01);
      case 'USDHKD': return (7.82 + variation * 0.05);
      case 'HKDUSD': return (0.128 + variation * 0.001);
      case 'USDTHB': return (35.8 + variation * 0.5);
      case 'THBUSD': return (0.028 + variation * 0.0004);
      case 'USDMYR': return (4.68 + variation * 0.05);
      case 'MYRUSD': return (0.214 + variation * 0.002);
      
      // European pairs
      case 'EURGBP': return (0.87 + variation * 0.01);
      case 'GBPEUR': return (1.15 + variation * 0.015);
      case 'EURJPY': return (175.0 + variation * 2.0);
      case 'JPYEUR': return (0.0057 + variation * 0.00008);
      case 'EURCHF': return (0.97 + variation * 0.01);
      case 'CHFEUR': return (1.03 + variation * 0.015);
      
      // Cross pairs
      case 'GBPJPY': return (187.0 + variation * 3.0);
      case 'JPYGBP': return (0.0053 + variation * 0.00008);
      case 'AUDJPY': return (98.0 + variation * 1.5);
      case 'JPYAUD': return (0.0102 + variation * 0.00015);
      case 'CADJPY': return (109.0 + variation * 1.5);
      case 'JPYCAD': return (0.0092 + variation * 0.00012);
      
      // Emerging markets
      case 'USDBRL': return (5.02 + variation * 0.1);
      case 'BRLUSD': return (0.199 + variation * 0.004);
      case 'USDMXN': return (17.8 + variation * 0.3);
      case 'MXNUSD': return (0.056 + variation * 0.001);
      case 'USDARS': return (825.0 + variation * 15.0);
      case 'ARSUSD': return (0.00121 + variation * 0.00002);
      case 'USDZAR': return (18.9 + variation * 0.3);
      case 'ZARUSD': return (0.053 + variation * 0.0008);
      
      // Crypto (mock rates)
      case 'BTCUSD': return (42500.0 + variation * 1000.0);
      case 'USDBTC': return (0.0000235 + variation * 0.0000005);
      case 'ETHUSD': return (2650.0 + variation * 50.0);
      case 'USDETH': return (0.000377 + variation * 0.000007);
      
      // Same currency
      default:
        if (from == to) return 1.0;
        
        // Generate reasonable rate for unknown pairs
        return _generateReasonableRate(from, to, variation);
    }
  }
  
  static double _generateReasonableRate(String from, String to, double variation) {
    // Create a deterministic but reasonable exchange rate
    final fromCode = from.hashCode.abs() % 1000;
    final toCode = to.hashCode.abs() % 1000;
    double ratio = (fromCode + 1) / (toCode + 1);
    
    // Adjust for common currency ranges
    if (ratio < 0.01) {
      ratio *= 100; // For high-value currencies like JPY
    } else if (ratio > 100) {
      ratio /= 100; // For low-value currencies
    }
    
    return ratio + (variation * ratio * 0.02);
  }
  
  static double _getRandomVariation() {
    // Generate consistent pseudo-random variation based on current time
    final now = DateTime.now();
    final seed = now.millisecondsSinceEpoch % 10000;
    return (seed / 10000.0 - 0.5); // Range from -0.5 to 0.5
  }
  
  // Mock delay to simulate network request
  static Future<ConversionResult> generateMockConversionWithDelay({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    await Future.delayed(delay);
    return generateMockConversion(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }
} 