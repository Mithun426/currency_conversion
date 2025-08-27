import 'package:equatable/equatable.dart';
class ConversionResult extends Equatable {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;
  final double exchangeRate;
  final DateTime timestamp;
  const ConversionResult({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.timestamp,
  });
  @override
  List<Object> get props => [
        amount,
        fromCurrency,
        toCurrency,
        convertedAmount,
        exchangeRate,
        timestamp,
      ];
} 