import 'package:equatable/equatable.dart';
abstract class CurrencyConversionEvent extends Equatable {
  const CurrencyConversionEvent();
  @override
  List<Object> get props => [];
}
class LoadCurrenciesEvent extends CurrencyConversionEvent {}
class ConvertCurrencyEvent extends CurrencyConversionEvent {
  final String amount;
  final String fromCurrency;
  final String toCurrency;
  final bool useMockData;
  const ConvertCurrencyEvent({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    this.useMockData = false,
  });
  @override
  List<Object> get props => [amount, fromCurrency, toCurrency, useMockData];
}
class SelectFromCurrencyEvent extends CurrencyConversionEvent {
  final String currencyCode;
  const SelectFromCurrencyEvent(this.currencyCode);
  @override
  List<Object> get props => [currencyCode];
}
class SelectToCurrencyEvent extends CurrencyConversionEvent {
  final String currencyCode;
  const SelectToCurrencyEvent(this.currencyCode);
  @override
  List<Object> get props => [currencyCode];
}
class SwapCurrenciesEvent extends CurrencyConversionEvent {
  @override
  List<Object> get props => [];
} 