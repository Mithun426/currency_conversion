import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime timestamp;

  const ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.timestamp,
  });

  @override
  List<Object> get props => [fromCurrency, toCurrency, rate, timestamp];
} 