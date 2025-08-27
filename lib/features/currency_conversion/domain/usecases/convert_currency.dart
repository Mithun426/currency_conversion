import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversion_result.dart';
import '../repositories/currency_repository.dart';

class ConvertCurrency implements UseCase<ConversionResult, ConvertCurrencyParams> {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  @override
  Future<Either<Failure, ConversionResult>> call(ConvertCurrencyParams params) async {
    return await repository.convertCurrency(
      amount: params.amount,
      from: params.from,
      to: params.to,
    );
  }
}

class ConvertCurrencyParams extends Equatable {
  final double amount;
  final String from;
  final String to;

  const ConvertCurrencyParams({
    required this.amount,
    required this.from,
    required this.to,
  });

  @override
  List<Object> get props => [amount, from, to];
} 