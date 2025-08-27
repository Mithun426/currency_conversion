import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/currency.dart';
import '../entities/exchange_rate.dart';
import '../entities/conversion_result.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<Currency>>> getAllCurrencies();
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String from,
    required String to,
  });
  Future<Either<Failure, ConversionResult>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });
} 