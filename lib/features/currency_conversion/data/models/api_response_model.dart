class ApiConversionResponse {
  final String base;
  final double amount;
  final ConversionResult result;

  ApiConversionResponse({
    required this.base,
    required this.amount,
    required this.result,
  });

  factory ApiConversionResponse.fromJson(Map<String, dynamic> json) {
    return ApiConversionResponse(
      base: json['base'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0, // <-- handle string
      result: ConversionResult.fromJson(json['result']),
    );
  }
}

class ConversionResult {
  final String targetCurrency;
  final double convertedAmount;
  final double rate;

  ConversionResult({
    required this.targetCurrency,
    required this.convertedAmount,
    required this.rate,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    // find currency key dynamically (the one that is NOT 'rate')
    final currencyKey = json.keys.firstWhere((k) => k != 'rate');
    return ConversionResult(
      targetCurrency: currencyKey,
      convertedAmount: (json[currencyKey] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
    );
  }

  @override
  String toString() =>
      "ConversionResult(target: $targetCurrency, amount: $convertedAmount, rate: $rate)";
}