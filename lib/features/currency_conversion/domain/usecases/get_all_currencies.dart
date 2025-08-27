import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';
class GetAllCurrencies implements UseCase<List<Currency>, NoParams> {
  final CurrencyRepository repository;
  GetAllCurrencies(this.repository);
  @override
  Future<Either<Failure, List<Currency>>> call(NoParams params) async {
    return await repository.getAllCurrencies();
  }
} 