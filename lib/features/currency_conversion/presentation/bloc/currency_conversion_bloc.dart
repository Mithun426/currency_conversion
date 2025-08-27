import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/mock_conversion_data.dart';
import '../../domain/usecases/get_all_currencies.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/input_converter.dart';
import '../../../../core/usecases/usecase.dart';
import 'currency_conversion_event.dart';
import 'currency_conversion_state.dart';
class CurrencyConversionBloc extends Bloc<CurrencyConversionEvent, CurrencyConversionState> {
  final GetAllCurrencies getAllCurrencies;
  final ConvertCurrency convertCurrency;
  final InputConverter inputConverter;
  static const String invalidInputFailureMessage =
      'Invalid Input - The number must be a positive number.';
  CurrencyConversionBloc({
    required this.getAllCurrencies,
    required this.convertCurrency,
    required this.inputConverter,
  }) : super(CurrencyConversionInitial()) {
    on<LoadCurrenciesEvent>(_onLoadCurrencies);
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<SelectFromCurrencyEvent>(_onSelectFromCurrency);
    on<SelectToCurrencyEvent>(_onSelectToCurrency);
    on<SwapCurrenciesEvent>(_onSwapCurrencies);
  }
  Future<void> _onLoadCurrencies(
    LoadCurrenciesEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    emit(CurrencyConversionLoading());
    final currenciesResult = await getAllCurrencies(const NoParams());
    await currenciesResult.fold(
      (failure) async {
        if (!emit.isDone) {
          emit(CurrencyConversionError(message: _mapFailureToMessage(failure)));
        }
      },
      (currencies) async {
        if (!emit.isDone) {
          emit(CurrencyConversionLoaded(
            currencies: currencies,
            selectedFromCurrency: 'USD',
            selectedToCurrency: 'EUR',
          ));
        }
      },
    );
  }
  Future<void> _onConvertCurrency(
    ConvertCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    final inputEither = inputConverter.stringToUnsignedDouble(event.amount);
    await inputEither.fold(
      (failure) async => emit(const CurrencyConversionError(message: invalidInputFailureMessage)),
      (amount) async {
        final currentState = state;
        emit(CurrencyConversionLoading());
        if (event.useMockData) {
          try {
            final result = await MockConversionData.generateMockConversionWithDelay(
              amount: amount,
              fromCurrency: event.fromCurrency,
              toCurrency: event.toCurrency,
            );
            if (!emit.isDone) {
              if (currentState is CurrencyConversionLoaded) {
                emit(currentState.copyWith(conversionResult: result));
              } else {
                emit(CurrencyConversionLoaded(
                  currencies: const [],
                  selectedFromCurrency: event.fromCurrency,
                  selectedToCurrency: event.toCurrency,
                  conversionResult: result,
                ));
              }
            }
          } catch (e) {
            if (!emit.isDone) {
              emit(const CurrencyConversionError(message: 'Unable to generate mock data. Please try again.'));
            }
          }
        } else {
          final conversionResult = await convertCurrency(ConvertCurrencyParams(
            amount: amount,
            from: event.fromCurrency,
            to: event.toCurrency,
          ));
          await conversionResult.fold(
            (failure) async {
              if (!emit.isDone) {
                emit(CurrencyConversionError(message: _mapFailureToMessage(failure)));
              }
            },
            (result) async {
              if (!emit.isDone) {
                if (currentState is CurrencyConversionLoaded) {
                  emit(currentState.copyWith(conversionResult: result));
                } else {
                  emit(CurrencyConversionLoaded(
                    currencies: const [],
                    selectedFromCurrency: event.fromCurrency,
                    selectedToCurrency: event.toCurrency,
                    conversionResult: result,
                  ));
                }
              }
            },
          );
        }
      },
    );
  }
  Future<void> _onSelectFromCurrency(
    SelectFromCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    if (state is CurrencyConversionLoaded) {
      final currentState = state as CurrencyConversionLoaded;
      emit(currentState.copyWith(selectedFromCurrency: event.currencyCode));
    }
  }
  Future<void> _onSelectToCurrency(
    SelectToCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    if (state is CurrencyConversionLoaded) {
      final currentState = state as CurrencyConversionLoaded;
      emit(currentState.copyWith(selectedToCurrency: event.currencyCode));
    }
  }
  Future<void> _onSwapCurrencies(
    SwapCurrenciesEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    if (state is CurrencyConversionLoaded) {
      final currentState = state as CurrencyConversionLoaded;
      emit(currentState.copyWith(
        selectedFromCurrency: currentState.selectedToCurrency,
        selectedToCurrency: currentState.selectedFromCurrency,
      ));
    }
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
} 