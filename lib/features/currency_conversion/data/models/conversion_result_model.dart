import '../../domain/entities/conversion_result.dart';

class ConversionResultModel extends ConversionResult {
  const ConversionResultModel({
    required super.amount,
    required super.fromCurrency,
    required super.toCurrency,
    required super.convertedAmount,
    required super.exchangeRate,
    required super.timestamp,
  });

  factory ConversionResultModel.fromJson(Map<String, dynamic> json) {
    return ConversionResultModel(
      amount: (json['amount'] as num).toDouble(),
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      convertedAmount: (json['converted_amount'] as num).toDouble(),
      exchangeRate: (json['exchange_rate'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] as num).toInt(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'converted_amount': convertedAmount,
      'exchange_rate': exchangeRate,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ConversionResultModel.fromEntity(ConversionResult entity) {
    return ConversionResultModel(
      amount: entity.amount,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      convertedAmount: entity.convertedAmount,
      exchangeRate: entity.exchangeRate,
      timestamp: entity.timestamp,
    );
  }
} 