import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/entities/conversion_result.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_data_source.dart';
import '../datasources/currency_local_data_source.dart';
import '../models/conversion_result_model.dart';
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Currency>>> getAllCurrencies() async {
    if (await networkInfo.isConnected) {
      try {
        final currencies = await remoteDataSource.getAllCurrencies();
        return Right(currencies);
      } on DioException catch (e) {
        return Left(ServerFailure(message: _getErrorMessage(e)));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String from,
    required String to,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final exchangeRate = await remoteDataSource.getExchangeRate(
          from: from,
          to: to,
        );
        return Right(exchangeRate);
      } on DioException catch (e) {
        return Left(ServerFailure(message: _getErrorMessage(e)));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure, ConversionResult>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final conversionResult = await remoteDataSource.convertCurrency(
          amount: amount,
          from: from,
          to: to,
        );
        return Right(conversionResult);
      } on DioException catch (e) {
        return Left(ServerFailure(message: _getErrorMessage(e)));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      default:
        return 'Network error occurred';
    }
  }
} 