import '../../domain/entities/exchange_rate.dart';

class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
    required super.timestamp,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] as num).toInt() * 1000,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'rate': rate,
      'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }
} 