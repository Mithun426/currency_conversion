import 'package:equatable/equatable.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/conversion_result.dart';
abstract class CurrencyConversionState extends Equatable {
  const CurrencyConversionState();
  @override
  List<Object?> get props => [];
}
class CurrencyConversionInitial extends CurrencyConversionState {}
class CurrencyConversionLoading extends CurrencyConversionState {}
class CurrencyConversionLoaded extends CurrencyConversionState {
  final List<Currency> currencies;
  final String selectedFromCurrency;
  final String selectedToCurrency;
  final ConversionResult? conversionResult;
  const CurrencyConversionLoaded({
    required this.currencies,
    required this.selectedFromCurrency,
    required this.selectedToCurrency,
    this.conversionResult,
  });
  @override
  List<Object?> get props => [
        currencies,
        selectedFromCurrency,
        selectedToCurrency,
        conversionResult,
      ];
  CurrencyConversionLoaded copyWith({
    List<Currency>? currencies,
    String? selectedFromCurrency,
    String? selectedToCurrency,
    ConversionResult? conversionResult,
  }) {
    return CurrencyConversionLoaded(
      currencies: currencies ?? this.currencies,
      selectedFromCurrency: selectedFromCurrency ?? this.selectedFromCurrency,
      selectedToCurrency: selectedToCurrency ?? this.selectedToCurrency,
      conversionResult: conversionResult ?? this.conversionResult,
    );
  }
}
class CurrencyConversionError extends CurrencyConversionState {
  final String message;
  const CurrencyConversionError({required this.message});
  @override
  List<Object> get props => [message];
} 